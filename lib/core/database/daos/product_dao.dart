import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/products_table.dart';
import '../tables/units_table.dart';
import '../tables/product_units_table.dart';
import '../tables/price_history_table.dart';
import '../../models/product_model.dart';
import '../../models/unit_model.dart';
import '../../models/product_unit_model.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products, Units, ProductUnits, PriceHistory])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(super.db);

  // Tous les produits actifs
  Future<List<ProductModel>> getActiveProducts() async {
    final rows = await (select(products)
      ..where((p) => p.actif.equals(true))
      ..orderBy([(p) => OrderingTerm.asc(p.nom)]))
        .get();
    return rows.map(_toProductModel).toList();
  }

  // Recherche produits
  Future<List<ProductModel>> searchProducts(String query) async {
    final q = '%${query.toLowerCase()}%';
    final rows = await (select(products)
      ..where((p) => p.actif.equals(true))
      ..where((p) => p.nom.lower().like(q))
      ..orderBy([(p) => OrderingTerm.asc(p.nom)]))
        .get();
    return rows.map(_toProductModel).toList();
  }

  // Produit par id
  Future<ProductModel?> getProductById(int id) async {
    final row = await (select(products)..where((p) => p.id.equals(id))).getSingleOrNull();
    return row != null ? _toProductModel(row) : null;
  }

  // Toutes les unites actives
  Future<List<UnitModel>> getActiveUnits() async {
    final rows = await (select(units)
      ..where((u) => u.actif.equals(true))
      ..orderBy([(u) => OrderingTerm.asc(u.nom)]))
        .get();
    return rows.map(_toUnitModel).toList();
  }

  // Unites d'un produit
  Future<List<ProductUnitModel>> getProductUnits(int produitId) async {
    final rows = await (select(productUnits)
      ..where((pu) => pu.produitId.equals(produitId))
      ..where((pu) => pu.actif.equals(true)))
        .get();
    return rows.map(_toProductUnitModel).toList();
  }

  // Toutes les combinaisons produit-unite actives avec JOIN
  Future<List<ProductUnitModel>> getAllProductUnitsWithDetails() async {
    final query = select(productUnits).join([
      innerJoin(products, products.id.equalsExp(productUnits.produitId)),
      innerJoin(units, units.id.equalsExp(productUnits.uniteId)),
    ])
      ..where(productUnits.actif.equals(true))
      ..where(products.actif.equals(true))
      ..orderBy([
        OrderingTerm.asc(products.nom),
        OrderingTerm.asc(units.nom),
      ]);

    final rows = await query.get();
    return rows.map((row) {
      final pu = row.readTable(productUnits);
      final p = row.readTable(products);
      final u = row.readTable(units);
      return ProductUnitModel(
        id: pu.id,
        produitId: pu.produitId,
        uniteId: pu.uniteId,
        prixUnitaire: pu.prixUnitaire,
        actif: pu.actif,
        dateModification: pu.dateModification,
        nomProduit: p.nom,
        nomUnite: u.nom,
        symbolesUnite: u.symbole,
      );
    }).toList();
  }

  // ProductUnit par id
  Future<ProductUnitModel?> getProductUnitById(int id) async {
    final query = select(productUnits).join([
      innerJoin(products, products.id.equalsExp(productUnits.produitId)),
      innerJoin(units, units.id.equalsExp(productUnits.uniteId)),
    ])
      ..where(productUnits.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return null;
    final pu = row.readTable(productUnits);
    final p = row.readTable(products);
    final u = row.readTable(units);
    return ProductUnitModel(
      id: pu.id,
      produitId: pu.produitId,
      uniteId: pu.uniteId,
      prixUnitaire: pu.prixUnitaire,
      actif: pu.actif,
      dateModification: pu.dateModification,
      nomProduit: p.nom,
      nomUnite: u.nom,
      symbolesUnite: u.symbole,
    );
  }

  // Creer produit
  Future<int> createProduct(ProductsCompanion companion) async {
    return into(products).insert(companion);
  }

  // Mettre a jour produit
  Future<bool> updateProduct(ProductsCompanion companion) async {
    return update(products).replace(companion);
  }

  // Desactiver produit
  Future<void> deactivateProduct(int id) async {
    await (update(products)..where((p) => p.id.equals(id))).write(
      const ProductsCompanion(actif: Value(false)),
    );
  }

  // Creer unite de produit
  Future<int> createProductUnit(ProductUnitsCompanion companion) async {
    return into(productUnits).insert(companion);
  }

  // Mettre a jour unite de produit
  Future<bool> updateProductUnit(ProductUnitsCompanion companion) async {
    return update(productUnits).replace(companion);
  }

  // Desactiver unite de produit
  Future<void> deactivateProductUnit(int id) async {
    await (update(productUnits)..where((pu) => pu.id.equals(id))).write(
      ProductUnitsCompanion(
        actif: const Value(false),
        dateModification: Value(DateTime.now()),
      ),
    );
  }

  // Creer historique de prix
  Future<int> createPriceHistory(PriceHistoryCompanion companion) async {
    return into(priceHistory).insert(companion);
  }

  // Historique prix d'un produit-unite
  Future<List<PriceHistoryData>> getPriceHistory(int produitUniteId) async {
    return (select(priceHistory)
      ..where((ph) => ph.produitUniteId.equals(produitUniteId))
      ..orderBy([(ph) => OrderingTerm.desc(ph.dateModification)]))
        .get();
  }

  // Creer unite globale
  Future<int> createUnit(UnitsCompanion companion) async {
    return into(units).insert(companion);
  }

  // Convertisseurs
  ProductModel _toProductModel(Product row) {
    return ProductModel(
      id: row.id,
      nom: row.nom,
      description: row.description,
      actif: row.actif,
      dateCreation: row.dateCreation,
    );
  }

  UnitModel _toUnitModel(Unit row) {
    return UnitModel(
      id: row.id,
      nom: row.nom,
      symbole: row.symbole,
      actif: row.actif,
    );
  }

  ProductUnitModel _toProductUnitModel(ProductUnit row) {
    return ProductUnitModel(
      id: row.id,
      produitId: row.produitId,
      uniteId: row.uniteId,
      prixUnitaire: row.prixUnitaire,
      actif: row.actif,
      dateModification: row.dateModification,
    );
  }
}