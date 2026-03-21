import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/payments_table.dart';
import '../tables/debts_table.dart';
import '../tables/users_table.dart';
import '../../models/payment_model.dart';

part 'payment_dao.g.dart';

@DriftAccessor(tables: [Payments, Debts, Users])
class PaymentDao extends DatabaseAccessor<AppDatabase> with _$PaymentDaoMixin {
  PaymentDao(super.db);

  // Paiements d'une ligne de dette
  Future<List<PaymentModel>> getPaymentsForDebt(int detteId) async {
    final query = select(payments).join([
      innerJoin(users, users.id.equalsExp(payments.enregistrePar)),
      innerJoin(debts, debts.id.equalsExp(payments.detteId)),
    ])
      ..where(payments.detteId.equals(detteId))
      ..orderBy([OrderingTerm.desc(payments.datePaiement)]);

    return (await query.get()).map((row) {
      final p = row.readTable(payments);
      final u = row.readTable(users);
      final d = row.readTable(debts);
      return PaymentModel(
        id: p.id,
        detteId: p.detteId,
        montantPaye: p.montantPaye,
        modePaiement: p.modePaiement,
        referencePaiement: p.referencePaiement,
        enregistrePar: p.enregistrePar,
        datePaiement: p.datePaiement,
        dateCreation: p.dateCreation,
        nomUtilisateur: u.nomComplet,
        numeroFacture: d.numeroFacture,
      );
    }).toList();
  }

  // Paiements d'un mois
  Future<List<PaymentModel>> getPaymentsByMonth(int month, int year) async {
    final rows = await (select(payments)
      ..where((p) => p.datePaiement.year.equals(year))
      ..where((p) => p.datePaiement.month.equals(month))
      ..orderBy([(p) => OrderingTerm.desc(p.datePaiement)]))
        .get();

    return rows.map((p) => PaymentModel(
      id: p.id,
      detteId: p.detteId,
      montantPaye: p.montantPaye,
      modePaiement: p.modePaiement,
      referencePaiement: p.referencePaiement,
      enregistrePar: p.enregistrePar,
      datePaiement: p.datePaiement,
      dateCreation: p.dateCreation,
    )).toList();
  }

  // Paiements par jour d'un mois (pour graphique evolution)
  Future<Map<int, double>> getDailyPayments(int month, int year) async {
    final rows = await (select(payments)
      ..where((p) => p.datePaiement.year.equals(year))
      ..where((p) => p.datePaiement.month.equals(month)))
        .get();

    final Map<int, double> result = {};
    for (final p in rows) {
      final day = p.datePaiement.day;
      result[day] = (result[day] ?? 0.0) + p.montantPaye;
    }
    return result;
  }

  // Enregistrer un paiement
  Future<int> createPayment(PaymentsCompanion companion) async {
    return into(payments).insert(companion);
  }

  // Verifier si une reference existe deja
  Future<bool> referenceExists(String reference) async {
    final row = await (select(payments)
      ..where((p) => p.referencePaiement.equals(reference)))
        .getSingleOrNull();
    return row != null;
  }

  // Generer une reference unique
  Future<String> generateUniqueReference(
      String clientName, DateTime date) async {
    final first = clientName.trim().split(' ').first;
    final normalized = first
        .toLowerCase()
        .replaceAll(RegExp(r'[àâä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[îï]'), 'i')
        .replaceAll(RegExp(r'[ôö]'), 'o')
        .replaceAll(RegExp(r'[ùûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-z0-9]'), '')
        .toUpperCase();

    final ds =
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    final base = '$normalized-$ds';

    String ref = base;
    int suffix = 2;
    while (await referenceExists(ref)) {
      ref = '$base-$suffix';
      suffix++;
    }
    return ref;
  }
}