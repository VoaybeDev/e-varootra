import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/tables/payments_table.dart';
import '../models/payment_model.dart';
import '../../app/utils/helpers.dart';

class PaymentService {
  final AppDatabase _db;

  PaymentService(this._db);

  // Enregistrer un paiement sur une facture
  Future<void> payInvoice({
    required String numeroFacture,
    required double montantTotal,
    required int enregistrePar,
    required String nomClient,
    required DateTime datePaiement,
    String modePaiement = 'Especes',
  }) async {
    if (montantTotal <= 0) throw Exception('Le montant doit etre positif');

    // Recuperer les lignes actives de la facture
    final lignes = await _db.debtDao.getInvoiceLines(numeroFacture);
    final lignesNonPayees = lignes.where((l) => l.montantRestant > 0).toList();

    if (lignesNonPayees.isEmpty) throw Exception('Cette facture est deja entierement payee');

    final totalRestant = lignesNonPayees.fold(0.0, (s, l) => s + l.montantRestant);
    if (montantTotal > totalRestant) {
      throw Exception('Le montant depasse le restant (${totalRestant.toStringAsFixed(0)} Ar)');
    }

    final ref = await _db.paymentDao.generateUniqueReference(nomClient, datePaiement);

    await _db.transaction(() async {
      double restePaiement = montantTotal;

      for (final ligne in lignesNonPayees) {
        if (restePaiement <= 0) break;

        final aDistribuer = restePaiement >= ligne.montantRestant
            ? ligne.montantRestant
            : restePaiement;

        restePaiement = (restePaiement - aDistribuer).clamp(0.0, double.infinity);

        final nouveauPaye = ligne.montantPaye + aDistribuer;
        final nouveauRestant = (ligne.montantTotal - nouveauPaye).clamp(0.0, double.infinity);
        final nouveauStatut = AppHelpers.computeStatus(
          total: ligne.montantTotal,
          paid: nouveauPaye,
        );

        await _db.debtDao.updateDebtPayment(
          id: ligne.id,
          montantPaye: nouveauPaye,
          montantRestant: nouveauRestant,
          statut: nouveauStatut,
        );

        await _db.paymentDao.createPayment(
          PaymentsCompanion(
            detteId: Value(ligne.id),
            montantPaye: Value(aDistribuer),
            modePaiement: Value(modePaiement),
            referencePaiement: Value(ref),
            enregistrePar: Value(enregistrePar),
            datePaiement: Value(datePaiement),
          ),
        );
      }
    });
  }

  // Recuperer historique paiements d'une ligne de dette
  Future<List<PaymentModel>> getPaymentsForDebt(int detteId) async {
    return _db.paymentDao.getPaymentsForDebt(detteId);
  }

  // Recuperer paiements par mois
  Future<List<PaymentModel>> getPaymentsByMonth(int month, int year) async {
    return _db.paymentDao.getPaymentsByMonth(month, year);
  }

  // Paiements journaliers pour graphique
  Future<Map<int, double>> getDailyPayments(int month, int year) async {
    return _db.paymentDao.getDailyPayments(month, year);
  }
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PaymentService(db);
});