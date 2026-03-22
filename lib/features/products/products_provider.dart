import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/product_dao.dart';
import '../../core/models/product_model.dart';
import '../../core/models/product_unit_model.dart';
import '../../core/models/unit_model.dart';
import '../../core/models/user_model.dart';
import '../auth/auth_provider.dart';

class ProductWithUnits {
  final ProductModel product;
  final List<ProductUnitWithHistory> units;
  const ProductWithUnits({required this.product, required this.units});
}

class ProductUnitWithHistory {
  final ProductUnitModel unit;
  final List<PriceHistoryEntry> history;
  const ProductUnitWithHistory({required this.unit, required this.history});
}

class ProductsNotifier
    extends StateNotifier<AsyncValue<List<ProductWithUnits>>> {
  final AppDatabase _db;
  final Ref _ref;

  ProductsNotifier(this._db, this._ref)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      state = const AsyncValue.loading();
      final products = await _db.productDao.getActiveProducts();
      final List<ProductWithUnits> result = [];

      for (final product in products) {
        // Utilise getProductUnitsWithDetails pour avoir nomUnite
        final units = await _db.productDao
            .getProductUnitsWithDetails(product.id);
        final List<ProductUnitWithHistory> unitsWithHistory = [];

        for (final unit in units) {
          final history =
          await _db.productDao.getPriceHistory(unit.id);
          unitsWithHistory
              .add(ProductUnitWithHistory(unit: unit, history: history));
        }

        result.add(ProductWithUnits(
            product: product, units: unitsWithHistory));
      }

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  String get _currentPseudo =>
      _ref.read(currentUserProvider)?.pseudo ?? 'inconnu';

  String get _currentRole =>
      UserModel.roleToString(
          _ref.read(currentUserProvider)?.role ??
              UserRole.utilisateur);

  Future<String?> createProduct({
    required String nom,
    String? description,
    required List<({String uniteName, double prix})> units,
  }) async {
    try {
      final productId = await _db.productDao.createProduct(
        ProductsCompanion(
          nom: Value(nom),
          description: description != null
              ? Value(description)
              : const Value.absent(),
        ),
      );

      final allUnits = await _db.productDao.getActiveUnits();

      for (final entry in units) {
        UnitModel? existingUnit;
        try {
          existingUnit = allUnits.firstWhere((u) =>
          u.nom.toLowerCase() == entry.uniteName.toLowerCase());
        } catch (_) {}

        int uniteId;
        if (existingUnit != null) {
          uniteId = existingUnit.id;
        } else {
          uniteId = await _db.productDao.createUnit(
            UnitsCompanion(
              nom: Value(entry.uniteName),
              symbole: Value(entry.uniteName.toLowerCase()),
            ),
          );
        }

        await _db.productDao.createProductUnit(
          ProductUnitsCompanion(
            produitId: Value(productId),
            uniteId: Value(uniteId),
            prixUnitaire: Value(entry.prix),
            dateModification: Value(DateTime.now()),
          ),
        );
      }

      await load();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateProduct({
    required int productId,
    required String nom,
    String? description,
    required List<({int? id, String uniteName, double prix})> units,
  }) async {
    try {
      await _db.productDao.updateProduct(
        ProductsCompanion(
          id: Value(productId),
          nom: Value(nom),
          description: description != null
              ? Value(description)
              : const Value.absent(),
        ),
      );

      final allUnits = await _db.productDao.getActiveUnits();
      // Utilise getProductUnits (sans join) pour la logique interne
      final existingUnits =
      await _db.productDao.getProductUnits(productId);

      final pseudo = _currentPseudo;
      final role = _currentRole;

      final keptIds =
      units.where((u) => u.id != null).map((u) => u.id!).toSet();

      for (final existing in existingUnits) {
        if (!keptIds.contains(existing.id)) {
          await _db.productDao.deactivateProductUnit(existing.id);
        }
      }

      for (final u in units) {
        UnitModel? existingUnit;
        try {
          existingUnit = allUnits.firstWhere((un) =>
          un.nom.toLowerCase() == u.uniteName.toLowerCase());
        } catch (_) {}

        int uniteId;
        if (existingUnit != null) {
          uniteId = existingUnit.id;
        } else {
          uniteId = await _db.productDao.createUnit(
            UnitsCompanion(
              nom: Value(u.uniteName),
              symbole: Value(u.uniteName.toLowerCase()),
            ),
          );
        }

        if (u.id != null) {
          final existing =
              existingUnits.where((e) => e.id == u.id).firstOrNull;

          if (existing != null && existing.prixUnitaire != u.prix) {
            // Enregistrer historique avec pseudo ET role
            await _db.productDao.createPriceHistory(
              produitUniteId: u.id!,
              ancienPrix: existing.prixUnitaire,
              nouveauPrix: u.prix,
              pseudo: pseudo,
              role: role,
            );
          }

          await _db.productDao.updateProductUnit(
            ProductUnitsCompanion(
              id: Value(u.id!),
              produitId: Value(productId),
              uniteId: Value(uniteId),
              prixUnitaire: Value(u.prix),
              dateModification: Value(DateTime.now()),
            ),
          );
        } else {
          await _db.productDao.createProductUnit(
            ProductUnitsCompanion(
              produitId: Value(productId),
              uniteId: Value(uniteId),
              prixUnitaire: Value(u.prix),
              dateModification: Value(DateTime.now()),
            ),
          );
        }
      }

      await load();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteProduct(int productId) async {
    try {
      final units = await _db.productDao.getProductUnits(productId);
      for (final unit in units) {
        await _db.productDao.deactivateProductUnit(unit.id);
      }
      await _db.productDao.deactivateProduct(productId);
      await load();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

final productsNotifierProvider = StateNotifierProvider<ProductsNotifier,
    AsyncValue<List<ProductWithUnits>>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductsNotifier(db, ref);
});

final allProductUnitsProvider =
FutureProvider<List<ProductUnitModel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.productDao.getAllProductUnitsWithDetails();
});