import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/debt_line_model.dart';
import '../../app/utils/constants.dart';
import '../../app/utils/helpers.dart';

class MonthStats {
  final int month;
  final int year;
  final int produitsActifs;
  final int clientsActifs;
  final int facturesActives;
  final int facturesPayees;
  final double montantRestant;
  final double paiementsRecus;
  final double totalDettesCreees;
  final double tauxRecouvrement;
  final double tauxSoldees;
  final double moyenneParDette;
  final String performance;

  const MonthStats({
    required this.month,
    required this.year,
    required this.produitsActifs,
    required this.clientsActifs,
    required this.facturesActives,
    required this.facturesPayees,
    required this.montantRestant,
    required this.paiementsRecus,
    required this.totalDettesCreees,
    required this.tauxRecouvrement,
    required this.tauxSoldees,
    required this.moyenneParDette,
    required this.performance,
  });
}

class TopClientStat {
  final int clientId;
  final String nomClient;
  final double montantTotal;
  final int nombreFactures;

  const TopClientStat({
    required this.clientId,
    required this.nomClient,
    required this.montantTotal,
    required this.nombreFactures,
  });
}

class TopProductStat {
  final int produitId;
  final String nomProduit;
  final double montantTotal;
  final double quantiteTotale;

  const TopProductStat({
    required this.produitId,
    required this.nomProduit,
    required this.montantTotal,
    required this.quantiteTotale,
  });
}

class VendeurStat {
  final int userId;
  final String nomVendeur;
  final String pseudo;
  final int nombreFactures;
  final double montantTotal;
  final double montantPaye;

  const VendeurStat({
    required this.userId,
    required this.nomVendeur,
    required this.pseudo,
    required this.nombreFactures,
    required this.montantTotal,
    required this.montantPaye,
  });
}

class RepartitionDettes {
  final int actives;
  final int partielles;
  final int payees;

  const RepartitionDettes({
    required this.actives,
    required this.partielles,
    required this.payees,
  });
}

class StatsService {
  final AppDatabase _db;

  StatsService(this._db);

  // Statistiques mensuelles
  Future<MonthStats> getMonthStats(int month, int year) async {
    final debts = await _db.debtDao.getDebtsByMonth(month, year);
    final clients = await _db.clientDao.getActiveClients();
    final products = await _db.productDao.getActiveProducts();

    // Grouper par numero de facture pour compter les factures
    final factures = <String, List<DebtLineModel>>{};
    for (final d in debts) {
      factures.putIfAbsent(d.numeroFacture, () => []).add(d);
    }

    // Stats par facture
    int facturesActives = 0;
    int facturesPayees = 0;
    double montantRestant = 0;
    double paiementsRecus = 0;
    double totalDettesCreees = 0;

    for (final entry in factures.entries) {
      final lignes = entry.value;
      final totLignes = lignes.fold(0.0, (s, l) => s + l.montantTotal);
      final payeLignes = lignes.fold(0.0, (s, l) => s + l.montantPaye);
      final resteLignes = lignes.fold(0.0, (s, l) => s + l.montantRestant);

      totalDettesCreees += totLignes;
      paiementsRecus += payeLignes;
      montantRestant += resteLignes;

      final statut = AppHelpers.computeStatus(total: totLignes, paid: payeLignes);
      if (statut == AppConstants.statusPaid) {
        facturesPayees++;
      } else {
        facturesActives++;
      }
    }

    final totalFactures = facturesActives + facturesPayees;
    final tauxRecouvrement = AppHelpers.recoveryRate(totalDettesCreees, paiementsRecus);
    final tauxSoldees = AppHelpers.paidRate(totalFactures, facturesPayees);
    final moyenne = AppHelpers.averageDebt(totalDettesCreees, totalFactures);
    final perf = AppHelpers.performanceLabelEmoji(tauxRecouvrement);

    return MonthStats(
      month: month,
      year: year,
      produitsActifs: products.length,
      clientsActifs: clients.length,
      facturesActives: facturesActives,
      facturesPayees: facturesPayees,
      montantRestant: montantRestant,
      paiementsRecus: paiementsRecus,
      totalDettesCreees: totalDettesCreees,
      tauxRecouvrement: tauxRecouvrement,
      tauxSoldees: tauxSoldees,
      moyenneParDette: moyenne,
      performance: perf,
    );
  }

  // Top 5 clients par montant du mois
  Future<List<TopClientStat>> getTopClients(int month, int year, {int limit = 5}) async {
    final debts = await _db.debtDao.getDebtsByMonth(month, year);

    final Map<int, TopClientStat> map = {};
    for (final d in debts) {
      final existing = map[d.clientId];
      if (existing == null) {
        map[d.clientId] = TopClientStat(
          clientId: d.clientId,
          nomClient: d.nomClient ?? 'Inconnu',
          montantTotal: d.montantTotal,
          nombreFactures: 1,
        );
      } else {
        map[d.clientId] = TopClientStat(
          clientId: existing.clientId,
          nomClient: existing.nomClient,
          montantTotal: existing.montantTotal + d.montantTotal,
          nombreFactures: existing.nombreFactures + 1,
        );
      }
    }

    final list = map.values.toList()
      ..sort((a, b) => b.montantTotal.compareTo(a.montantTotal));
    return list.take(limit).toList();
  }

  // Top 5 produits par montant du mois
  Future<List<TopProductStat>> getTopProducts(int month, int year, {int limit = 5}) async {
    final debts = await _db.debtDao.getDebtsByMonth(month, year);

    final Map<String, TopProductStat> map = {};
    for (final d in debts) {
      final key = d.nomProduit ?? 'Inconnu';
      final existing = map[key];
      if (existing == null) {
        map[key] = TopProductStat(
          produitId: d.produitUniteId,
          nomProduit: key,
          montantTotal: d.montantTotal,
          quantiteTotale: d.quantite,
        );
      } else {
        map[key] = TopProductStat(
          produitId: existing.produitId,
          nomProduit: key,
          montantTotal: existing.montantTotal + d.montantTotal,
          quantiteTotale: existing.quantiteTotale + d.quantite,
        );
      }
    }

    final list = map.values.toList()
      ..sort((a, b) => b.montantTotal.compareTo(a.montantTotal));
    return list.take(limit).toList();
  }

  // Repartition des dettes du mois
  Future<RepartitionDettes> getRepartitionDettes(int month, int year) async {
    final debts = await _db.debtDao.getDebtsByMonth(month, year);

    // Grouper par facture
    final Map<String, List<DebtLineModel>> factures = {};
    for (final d in debts) {
      factures.putIfAbsent(d.numeroFacture, () => []).add(d);
    }

    int actives = 0, partielles = 0, payees = 0;

    for (final lignes in factures.values) {
      final tot = lignes.fold(0.0, (s, l) => s + l.montantTotal);
      final pay = lignes.fold(0.0, (s, l) => s + l.montantPaye);
      final statut = AppHelpers.computeStatus(total: tot, paid: pay);

      if (statut == AppConstants.statusPaid) {
        payees++;
      } else if (statut == AppConstants.statusPartial) {
        partielles++;
      } else {
        actives++;
      }
    }

    return RepartitionDettes(actives: actives, partielles: partielles, payees: payees);
  }

  // Performance vendeurs du mois
  Future<List<VendeurStat>> getVendeurStats(int month, int year) async {
    final debts = await _db.debtDao.getDebtsByMonth(month, year);
    final users = await _db.userDao.getAllUsers();

    // Grouper par facture puis par vendeur
    final Map<String, List<DebtLineModel>> factures = {};
    for (final d in debts) {
      factures.putIfAbsent(d.numeroFacture, () => []).add(d);
    }

    final Map<int, Map<String, dynamic>> vendeurMap = {};

    for (final entry in factures.entries) {
      final lignes = entry.value;
      if (lignes.isEmpty) continue;
      final uid = lignes.first.enregistrePar;
      final tot = lignes.fold(0.0, (s, l) => s + l.montantTotal);
      final pay = lignes.fold(0.0, (s, l) => s + l.montantPaye);

      if (!vendeurMap.containsKey(uid)) {
        vendeurMap[uid] = {'nb': 0, 'tot': 0.0, 'pay': 0.0};
      }
      vendeurMap[uid]!['nb'] = (vendeurMap[uid]!['nb'] as int) + 1;
      vendeurMap[uid]!['tot'] = (vendeurMap[uid]!['tot'] as double) + tot;
      vendeurMap[uid]!['pay'] = (vendeurMap[uid]!['pay'] as double) + pay;
    }

    final result = <VendeurStat>[];
    for (final entry in vendeurMap.entries) {
      final user = users.firstWhere(
            (u) => u.id == entry.key,
        orElse: () => users.first,
      );
      result.add(VendeurStat(
        userId: entry.key,
        nomVendeur: user.nomComplet,
        pseudo: user.pseudo,
        nombreFactures: entry.value['nb'] as int,
        montantTotal: entry.value['tot'] as double,
        montantPaye: entry.value['pay'] as double,
      ));
    }

    result.sort((a, b) => b.montantTotal.compareTo(a.montantTotal));
    return result;
  }

  // Evolution journaliere des paiements
  Future<List<double>> getDailyPaymentsEvolution(int month, int year) async {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final dailyMap = await _db.paymentDao.getDailyPayments(month, year);
    return List.generate(daysInMonth, (i) => dailyMap[i + 1] ?? 0.0);
  }
}

final statsServiceProvider = Provider<StatsService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return StatsService(db);
});