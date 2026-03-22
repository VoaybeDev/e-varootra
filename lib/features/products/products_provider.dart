import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/tables/products_table.dart';
import '../../core/database/tables/units_table.dart';
import '../../core/database/tables/product_units_table.dart';
import '../../core/database/tables/price_history_table.dart';
import '../../core/models/product_model.dart';
import '../../core/models/product_unit_model.dart';
import '../../core/models/unit_model.dart';

// Modele complet produit avec ses unites
class ProductWithUnits {
  final ProductModel product;
  final List<ProductUnitWithHistory> units;

  const ProductWithUnits({required this.product, required this.units});
}

class ProductUnitWithHistory {
  final ProductUnitModel productUnit;
  final List<PriceHistoryData> history;

  const ProductUnitWithHistory({
    required this.productUnit,
    required this.history,
  });
}

// Input pour creer/modifier un produit
class ProductUnitInput {
  final int? id;
  final String label;
  final double prix;

  const ProductUnitInput({this.id, required this.label, required this.prix});
}

class ProductsNotifier extends StateNotifier<AsyncValue<List<ProductWithUnits>>> {
  final AppDatabase _db;

  ProductsNotifier(this._db) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load([String search = '']) async {
    try {
      state = const AsyncValue.loading();
      final products = search.trim().isEmpty
          ? await _db.productDao.getActiveProducts()
          : await _db.productDao.searchProducts(search);

      final result = <ProductWithUnits>[];
      for (final p in products) {
        final pus = await _db.productDao.getProductUnits(p.id);
        final unitsWithHistory = <ProductUnitWithHistory>[];
        for (final pu in pus) {
          final hist = await _db.productDao.getPriceHistory(pu.id);
          // Enrichir avec les noms
          final unit = await _db.productDao.getProductUnitById(pu.id);
          unitsWithHistory.add(ProductUnitWithHistory(
            productUnit: unit ?? pu,
            history: hist,
          ));
        }
        result.add(ProductWithUnits(product: p, units: unitsWithHistory));
      }
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<String?> createProduct({
    required String nom,
    required String description,
    required List<ProductUnitInput> unitInputs,
    required int userId,
  }) async {
    try {
      if (unitInputs.isEmpty) return 'Ajoutez au moins une unite';

      final productId = await _db.productDao.createProduct(
        ProductsCompanion(
          nom: Value(nom),
          description: Value(description),
        ),
      );

      for (final u in unitInputs) {
        // Creer l'unite
        final unitId = await _db.productDao.createUnit(
          UnitsCompanion.insert(nom: u.label, symbole: Value(u.label)),
        );
        await _db.productDao.createProductUnit(
          ProductUnitsCompanion.insert(
            produitId: productId,
            uniteId: unitId,
            prixUnitaire: Value(u.prix),
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
    required String description,
    required List<ProductUnitInput> unitInputs,
    required int userId,
  }) async {
    try {
      await _db.productDao.updateProduct(
        ProductsCompanion(
          id: Value(productId),
          nom: Value(nom),
          description: Value(description),
        ),
      );

      final existingPUs = await _db.productDao.getProductUnits(productId);

      for (final u in unitInputs) {
        if (u.id != null) {
          // Modifier existant
          final existing = existingPUs.firstWhere(
                (pu) => pu.id == u.id,
            orElse: () => existingPUs.first,
          );
          // Enregistrer historique si prix change
          if (existing.prixUnitaire != u.prix && u.prix > 0) {
            await _db.productDao.createPriceHistory(
              PriceHistoryCompanion.insert(
                produitUniteId: u.id!,
                ancienPrix: existing.prixUnitaire,
                nouveauPrix: u.prix,
                utilisateurId: userId,
              ),
            );
          }
          await _db.productDao.updateProductUnit(
            ProductUnitsCompanion(
              id: Value(u.id!),
              produitId: Value(productId),
              uniteId: Value(existing.uniteId),
              prixUnitaire: Value(u.prix),
              dateModification: Value(DateTime.now()),
            ),
          );
        } else {
          // Nouvelle unite
          final unitId = await _db.productDao.createUnit(
            UnitsCompanion.insert(nom: u.label, symbole: Value(u.label)),
          );
          await _db.productDao.createProductUnit(
            ProductUnitsCompanion.insert(
              produitId: productId,
              uniteId: unitId,
              prixUnitaire: Value(u.prix),
            ),
          );
        }
      }

      // Desactiver les unites supprimees
      final inputIds = unitInputs.where((u) => u.id != null).map((u) => u.id!).toSet();
      for (final pu in existingPUs) {
        if (!inputIds.contains(pu.id)) {
          await _db.productDao.deactivateProductUnit(pu.id);
        }
      }

      await load();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deactivate(int id) async {
    try {
      await _db.productDao.deactivateProduct(id);
      await load();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

final productsNotifierProvider =
StateNotifierProvider<ProductsNotifier, AsyncValue<List<ProductWithUnits>>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductsNotifier(db);
});

// Toutes les combinaisons produit-unite pour la creation de facture
final allProductUnitsProvider = FutureProvider<List<ProductUnitModel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.productDao.getAllProductUnitsWithDetails();
});

// Unites globales
final unitsProvider = FutureProvider<List<UnitModel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.productDao.getActiveUnits();
});