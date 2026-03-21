import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/debts_table.dart';
import '../tables/clients_table.dart';
import '../tables/product_units_table.dart';
import '../tables/products_table.dart';
import '../tables/units_table.dart';
import '../../models/debt_line_model.dart';

part 'debt_dao.g.dart';

@DriftAccessor(tables: [Debts, Clients, ProductUnits, Products, Units])
class DebtDao extends DatabaseAccessor<AppDatabase> with _$DebtDaoMixin {
  DebtDao(super.db);

  // Toutes les lignes de dette actives (non payees) avec details
  Future<List<DebtLineModel>> getActiveDebts() async {
    final query = select(debts).join([
      innerJoin(clients, clients.id.equalsExp(debts.clientId)),
      innerJoin(productUnits, productUnits.id.equalsExp(debts.produitUniteId)),
      innerJoin(products, products.id.equalsExp(productUnits.produitId)),
      innerJoin(units, units.id.equalsExp(productUnits.uniteId)),
    ])
      ..where(debts.statut.isNotValue('payee'))
      ..orderBy([OrderingTerm.desc(debts.dateDette)]);

    return (await query.get()).map((row) => _toModelWithJoin(row)).toList();
  }

  // Dettes d'un client (non payees)
  Future<List<DebtLineModel>> getClientActiveDebts(int clientId) async {
    final query = select(debts).join([
      innerJoin(clients, clients.id.equalsExp(debts.clientId)),
      innerJoin(productUnits, productUnits.id.equalsExp(debts.produitUniteId)),
      innerJoin(products, products.id.equalsExp(productUnits.produitId)),
      innerJoin(units, units.id.equalsExp(productUnits.uniteId)),
    ])
      ..where(debts.clientId.equals(clientId))
      ..where(debts.statut.isNotValue('payee'))
      ..orderBy([OrderingTerm.desc(debts.dateDette)]);

    return (await query.get()).map((row) => _toModelWithJoin(row)).toList();
  }

  // Dettes payees d'un client (archive)
  Future<List<DebtLineModel>> getClientPaidDebts(int clientId) async {
    final query = select(debts).join([
      innerJoin(clients, clients.id.equalsExp(debts.clientId)),
      innerJoin(productUnits, productUnits.id.equalsExp(debts.produitUniteId)),
      innerJoin(products, products.id.equalsExp(productUnits.produitId)),
      innerJoin(units, units.id.equalsExp(productUnits.uniteId)),
    ])
      ..where(debts.clientId.equals(clientId))
      ..where(debts.statut.equals('payee'))
      ..orderBy([OrderingTerm.desc(debts.dateDette)]);

    return (await query.get()).map((row) => _toModelWithJoin(row)).toList();
  }

  // Toutes les dettes payees (archive globale)
  Future<List<DebtLineModel>> getAllPaidDebts() async {
    final query = select(debts).join([
      innerJoin(clients, clients.id.equalsExp(debts.clientId)),
      innerJoin(productUnits, productUnits.id.equalsExp(debts.produitUniteId)),
      innerJoin(products, products.id.equalsExp(productUnits.produitId)),
      innerJoin(units, units.id.equalsExp(productUnits.uniteId)),
    ])
      ..where(debts.statut.equals('payee'))
      ..orderBy([OrderingTerm.desc(debts.dateDette)]);

    return (await query.get()).map((row) => _toModelWithJoin(row)).toList();
  }

  // Lignes d'une facture par numero
  Future<List<DebtLineModel>> getInvoiceLines(String numeroFacture) async {
    final query = select(debts).join([
      innerJoin(clients, clients.id.equalsExp(debts.clientId)),
      innerJoin(productUnits, productUnits.id.equalsExp(debts.produitUniteId)),
      innerJoin(products, products.id.equalsExp(productUnits.produitId)),
      innerJoin(units, units.id.equalsExp(productUnits.uniteId)),
    ])
      ..where(debts.numeroFacture.equals(numeroFacture))
      ..orderBy([OrderingTerm.asc(debts.id)]);

    return (await query.get()).map((row) => _toModelWithJoin(row)).toList();
  }

  // Dettes d'un mois donne
  Future<List<DebtLineModel>> getDebtsByMonth(int month, int year) async {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';
    final query = select(debts).join([
      innerJoin(clients, clients.id.equalsExp(debts.clientId)),
      innerJoin(productUnits, productUnits.id.equalsExp(debts.produitUniteId)),
      innerJoin(products, products.id.equalsExp(productUnits.produitId)),
      innerJoin(units, units.id.equalsExp(productUnits.uniteId)),
    ])
      ..where(debts.dateDette.year.equals(year))
      ..where(debts.dateDette.month.equals(month))
      ..orderBy([OrderingTerm.desc(debts.dateDette)]);

    return (await query.get()).map((row) => _toModelWithJoin(row)).toList();
  }

  // Prochain numero de facture
  Future<String> getNextInvoiceNumber(int year) async {
    final rows = await (select(debts)
      ..where((d) => d.numeroFacture.like('FAC-$year-%')))
        .get();

    int maxSeq = 0;
    for (final row in rows) {
      final parts = row.numeroFacture.split('-');
      if (parts.length >= 3) {
        final seq = int.tryParse(parts.last) ?? 0;
        if (seq > maxSeq) maxSeq = seq;
      }
    }
    final seq = (maxSeq + 1).toString().padLeft(3, '0');
    return 'FAC-$year-$seq';
  }

  // Creer une ligne de dette
  Future<int> createDebt(DebtsCompanion companion) async {
    return into(debts).insert(companion);
  }

  // Mettre a jour une ligne de dette
  Future<bool> updateDebt(DebtsCompanion companion) async {
    return update(debts).replace(companion);
  }

  // Mettre a jour montants et statut d'une ligne
  Future<void> updateDebtPayment({
    required int id,
    required double montantPaye,
    required double montantRestant,
    required String statut,
  }) async {
    await (update(debts)..where((d) => d.id.equals(id))).write(
      DebtsCompanion(
        montantPaye: Value(montantPaye),
        montantRestant: Value(montantRestant),
        statut: Value(statut),
        dateModification: Value(DateTime.now()),
      ),
    );
  }

  // Dette par id
  Future<DebtLineModel?> getDebtById(int id) async {
    final query = select(debts).join([
      innerJoin(clients, clients.id.equalsExp(debts.clientId)),
      innerJoin(productUnits, productUnits.id.equalsExp(debts.produitUniteId)),
      innerJoin(products, products.id.equalsExp(productUnits.produitId)),
      innerJoin(units, units.id.equalsExp(productUnits.uniteId)),
    ])
      ..where(debts.id.equals(id));

    final row = await query.getSingleOrNull();
    return row != null ? _toModelWithJoin(row) : null;
  }

  // Convertir ligne avec JOIN
  DebtLineModel _toModelWithJoin(TypedResult row) {
    final d = row.readTable(debts);
    final c = row.readTable(clients);
    final p = row.readTable(products);
    final u = row.readTable(units);

    return DebtLineModel(
      id: d.id,
      numeroFacture: d.numeroFacture,
      clientId: d.clientId,
      produitUniteId: d.produitUniteId,
      quantite: d.quantite,
      prixUnitaireFige: d.prixUnitaireFige,
      montantTotal: d.montantTotal,
      montantPaye: d.montantPaye,
      montantRestant: d.montantRestant,
      statut: d.statut,
      enregistrePar: d.enregistrePar,
      dateDette: d.dateDette,
      dateModification: d.dateModification,
      nomClient: c.nomComplet,
      nomProduit: p.nom,
      nomUnite: u.nom,
    );
  }
}