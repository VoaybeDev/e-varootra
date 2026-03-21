import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/stats_service.dart';

// Mois selectionne pour le dashboard
class DashboardMonthNotifier extends StateNotifier<(int, int)> {
  DashboardMonthNotifier()
      : super((DateTime.now().month, DateTime.now().year));

  void previous() {
    int m = state.$1 - 1;
    int y = state.$2;
    if (m < 1) { m = 12; y--; }
    state = (m, y);
  }

  void next() {
    final now = DateTime.now();
    int m = state.$1 + 1;
    int y = state.$2;
    if (m > 12) { m = 1; y++; }
    if (y > now.year || (y == now.year && m > now.month)) return;
    state = (m, y);
  }

  bool get canGoNext {
    final now = DateTime.now();
    return !(state.$2 == now.year && state.$1 >= now.month);
  }

  int get month => state.$1;
  int get year => state.$2;
}

final dashboardMonthProvider =
StateNotifierProvider<DashboardMonthNotifier, (int, int)>((ref) {
  return DashboardMonthNotifier();
});

// Stats du mois dashboard
final dashboardStatsProvider = FutureProvider<MonthStats>((ref) async {
  final service = ref.watch(statsServiceProvider);
  final (month, year) = ref.watch(dashboardMonthProvider);
  return service.getMonthStats(month, year);
});

// Top clients
final topClientsProvider = FutureProvider<List<TopClientStat>>((ref) async {
  final service = ref.watch(statsServiceProvider);
  final (month, year) = ref.watch(dashboardMonthProvider);
  return service.getTopClients(month, year);
});

// Top produits
final topProductsProvider = FutureProvider<List<TopProductStat>>((ref) async {
  final service = ref.watch(statsServiceProvider);
  final (month, year) = ref.watch(dashboardMonthProvider);
  return service.getTopProducts(month, year);
});

// Repartition dettes
final repartitionDettesProvider = FutureProvider<RepartitionDettes>((ref) async {
  final service = ref.watch(statsServiceProvider);
  final (month, year) = ref.watch(dashboardMonthProvider);
  return service.getRepartitionDettes(month, year);
});

// Performance vendeurs
final vendeurStatsProvider = FutureProvider<List<VendeurStat>>((ref) async {
  final service = ref.watch(statsServiceProvider);
  final (month, year) = ref.watch(dashboardMonthProvider);
  return service.getVendeurStats(month, year);
});

// Evolution journaliere paiements
final dailyPaymentsProvider = FutureProvider<List<double>>((ref) async {
  final service = ref.watch(statsServiceProvider);
  final (month, year) = ref.watch(dashboardMonthProvider);
  return service.getDailyPaymentsEvolution(month, year);
});