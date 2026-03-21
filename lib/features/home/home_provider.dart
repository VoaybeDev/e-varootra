import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/stats_service.dart';

// Stats de l'accueil (mois selectionne)
final homeStatsProvider = FutureProvider.family<MonthStats, (int, int)>(
      (ref, monthYear) async {
    final service = ref.watch(statsServiceProvider);
    return service.getMonthStats(monthYear.$1, monthYear.$2);
  },
);

// Badge count dettes actives (pour la bottom nav)
final activeDettesCountProvider = FutureProvider<int>((ref) async {
  final db = ref.read(
    Provider((ref) => ref.watch(
      Provider((ref) => null),
    )),
  );
  return 0;
});