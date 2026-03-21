import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/tables/debts_table.dart';
import '../models/debt_line_model.dart';
import '../models/invoice_model.dart';
import '../models/payment_model.dart';
import '../models/client_model.dart';
import '../../app/utils/constants.dart';
import '../../app/utils/helpers.dart';

class InvoiceLineInput {
  final int produitUniteId;
  final double quantite;
  final double prixUnitaire;

  const InvoiceLineInput({
    required this.produitUniteId,
    required this.quantite,
    required this.prixUnitaire,
  });
}

class InvoiceService {
  final AppDatabase _db;

  InvoiceService(this._db);

  // Creer une facture complete (atomique)
  Future<String> createInvoice({
    required int clientId,
    required DateTime dateDette,
    required List<InvoiceLineInput> lignes,
    required int enregistrePar,
    double paiementInitial = 0,
  }) async {
    if (lignes.isEmpty) throw Exception('La facture doit avoir au moins une ligne');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(dateDette.year, dateDette.month, dateDette.day);
    if (dateOnly.isAfter(today)) {
      throw Exception('La date ne peut pas etre dans le futur');
    }

    final year = dateDette.year;
    final numeroFacture = await _db.debtDao.getNextInvoiceNumber(year);

    final totalFacture = lignes.fold(0.0, (s, l) => s + l.quantite * l.prixUnitaire);
    final payInitial = paiementInitial.clamp(0.0, totalFacture);

    // Repartition du paiement initial sur les lignes
    double restePaiement = payInitial;

    await _db.transaction(() async {
      for (final ligne in lignes) {
        final montantLigne = ligne.quantite * ligne.prixUnitaire;
        final payeLigne = restePaiement >= montantLigne
            ? montantLigne
            : restePaiement.clamp(0.0, montantLigne);
        restePaiement = (restePaiement - payeLigne).clamp(0.0, double.infinity);
        final resteLigne = montantLigne - payeLigne;
        final statut = AppHelpers.computeStatus(
          total: montantLigne,
          paid: payeLigne,
        );

        await _db.debtDao.createDebt(
          DebtsCompanion.insert(
            numeroFacture: numeroFacture,
            clientId: clientId,
            produitUniteId: ligne.produitUniteId,
            quantite: ligne.quantite,
            prixUnitaireFige: ligne.prixUnitaire,
            montantTotal: montantLigne,
            montantPaye: Value(payeLigne),
            montantRestant: resteLigne,
            statut: statut,
            enregistrePar: enregistrePar,
            dateDette: dateDette,
          ),
        );
      }

      // Enregistrer paiement initial si > 0
      if (payInitial > 0) {
        final client = await _db.clientDao.getClientById(clientId);
        final nomClient = client?.nomComplet ?? '';
        final ref = await _db.paymentDao.generateUniqueReference(nomClient, dateDette);

        // Recuperer les lignes creees pour ce numero de facture
        final lignesCreees = await _db.debtDao.getInvoiceLines(numeroFacture);
        for (final ligne in lignesCreees) {
          if (ligne.montantPaye > 0) {
            await _db.paymentDao.createPayment(
              PaymentsCompanion.insert(
                detteId: ligne.id,
                montantPaye: ligne.montantPaye,
                modePaiement: 'Especes',
                referencePaiement: Value(ref),
                enregistrePar: enregistrePar,
                datePaiement: dateDette,
              ),
            );
          }
        }
      }
    });

    return numeroFacture;
  }

  // Recuperer une facture complete par numero
  Future<InvoiceModel?> getInvoice(String numeroFacture) async {
    final lignes = await _db.debtDao.getInvoiceLines(numeroFacture);
    if (lignes.isEmpty) return null;

    final firstLigne = lignes.first;
    final client = await _db.clientDao.getClientById(firstLigne.clientId);
    if (client == null) return null;

    final vendeur = await _db.userDao.getUserById(firstLigne.enregistrePar);

    // Recuperer tous les paiements des lignes
    final List<PaymentModel> allPaiements = [];
    for (final ligne in lignes) {
      final paiements = await _db.paymentDao.getPaymentsForDebt(ligne.id);
      allPaiements.addAll(paiements);
    }

    // Dedupliquer par reference
    final seen = <String>{};
    final paiementsUniques = allPaiements.where((p) {
      if (seen.contains(p.referencePaiement)) return false;
      seen.add(p.referencePaiement);
      return true;
    }).toList();

    return InvoiceModel(
      numeroFacture: numeroFacture,
      clientId: client.id,
      nomClient: client.nomComplet,
      telephoneClient: client.telephone,
      dateDette: firstLigne.dateDette,
      lignes: lignes,
      paiements: paiementsUniques,
      enregistrePar: firstLigne.enregistrePar,
      nomVendeur: vendeur?.nomComplet ?? 'Inconnu',
    );
  }

  // Recuperer factures groupees par client (dettes actives)
  Future<Map<ClientModel, List<InvoiceModel>>> getActiveInvoicesByClient() async {
    final allDebts = await _db.debtDao.getActiveDebts();

    // Grouper par numero de facture
    final Map<String, List<DebtLineModel>> byFacture = {};
    for (final d in allDebts) {
      byFacture.putIfAbsent(d.numeroFacture, () => []).add(d);
    }

    // Grouper par client
    final Map<int, List<InvoiceModel>> byClient = {};
    final Map<int, ClientModel> clients = {};

    for (final entry in byFacture.entries) {
      final lignes = entry.value;
      if (lignes.isEmpty) continue;

      final clientId = lignes.first.clientId;
      final client = await _db.clientDao.getClientById(clientId);
      if (client == null) continue;

      clients[clientId] = client;

      final vendeur = await _db.userDao.getUserById(lignes.first.enregistrePar);

      final invoice = InvoiceModel(
        numeroFacture: entry.key,
        clientId: clientId,
        nomClient: client.nomComplet,
        telephoneClient: client.telephone,
        dateDette: lignes.first.dateDette,
        lignes: lignes,
        paiements: const [],
        enregistrePar: lignes.first.enregistrePar,
        nomVendeur: vendeur?.nomComplet ?? 'Inconnu',
      );

      byClient.putIfAbsent(clientId, () => []).add(invoice);
    }

    // Construire la map finale
    final Map<ClientModel, List<InvoiceModel>> result = {};
    for (final entry in byClient.entries) {
      final client = clients[entry.key]!;
      result[client] = entry.value
        ..sort((a, b) => b.dateDette.compareTo(a.dateDette));
    }

    return result;
  }

  // Recuperer factures payees groupees par client (archive)
  Future<Map<ClientModel, List<InvoiceModel>>> getPaidInvoicesByClient() async {
    final allDebts = await _db.debtDao.getAllPaidDebts();

    final Map<String, List<DebtLineModel>> byFacture = {};
    for (final d in allDebts) {
      byFacture.putIfAbsent(d.numeroFacture, () => []).add(d);
    }

    final Map<int, List<InvoiceModel>> byClient = {};
    final Map<int, ClientModel> clients = {};

    for (final entry in byFacture.entries) {
      final lignes = entry.value;
      if (lignes.isEmpty) continue;

      final clientId = lignes.first.clientId;
      final client = await _db.clientDao.getClientById(clientId);
      if (client == null) continue;

      clients[clientId] = client;
      final vendeur = await _db.userDao.getUserById(lignes.first.enregistrePar);

      final invoice = InvoiceModel(
        numeroFacture: entry.key,
        clientId: clientId,
        nomClient: client.nomComplet,
        telephoneClient: client.telephone,
        dateDette: lignes.first.dateDette,
        lignes: lignes,
        paiements: const [],
        enregistrePar: lignes.first.enregistrePar,
        nomVendeur: vendeur?.nomComplet ?? 'Inconnu',
      );

      byClient.putIfAbsent(clientId, () => []).add(invoice);
    }

    final Map<ClientModel, List<InvoiceModel>> result = {};
    for (final entry in byClient.entries) {
      final client = clients[entry.key]!;
      result[client] = entry.value
        ..sort((a, b) => b.dateDette.compareTo(a.dateDette));
    }

    return result;
  }
}

final invoiceServiceProvider = Provider<InvoiceService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return InvoiceService(db);
});