import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/services/stats_service.dart';

// Stats de l'accueil selon le mois selectionne
final homeStatsProvider = FutureProvider.family<MonthStats, (int, int)>(
      (ref, monthYear) async {
    final service = ref.watch(statsServiceProvider);
    return service.getMonthStats(monthYear.$1, monthYear.$2);
  },
);

// Badge count dettes actives pour la bottom nav
final activeDettesCountProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final debts = await db.debtDao.getActiveDebts();
  // Compter les factures uniques non payees
  final nums = debts.map((d) => d.numeroFacture).toSet();
  return nums.length;
});