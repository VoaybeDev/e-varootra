import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/formatters.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_text.dart';
import '../../core/widgets/month_navigator.dart';
import '../dashboard/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (month, year) = ref.watch(dashboardMonthProvider);
    final monthNotifier = ref.read(dashboardMonthProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardStatsProvider);
            ref.invalidate(topClientsProvider);
            ref.invalidate(topProductsProvider);
            ref.invalidate(repartitionDettesProvider);
            ref.invalidate(vendeurStatsProvider);
            ref.invalidate(dailyPaymentsProvider);
          },
          color: AppColors.accent,
          backgroundColor: AppColors.bgCard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                GradientText(
                  'Tableau de bord',
                  gradient: AppGradients.brand,
                  style: AppTextStyles.headlineLarge,
                ),

                const SizedBox(height: 14),

                // Navigateur mois
                MonthNavigator(
                  month: month,
                  year: year,
                  onPrevious: monthNotifier.previous,
                  onNext: monthNotifier.canGoNext
                      ? monthNotifier.next
                      : null,
                ),

                const SizedBox(height: 14),

                // Top clients
                _TopClientsCard(month: month, year: year),

                const SizedBox(height: 10),

                // Top produits
                _TopProductsCard(month: month, year: year),

                const SizedBox(height: 10),

                // Repartition dettes
                _RepartitionCard(month: month, year: year),

                const SizedBox(height: 10),

                // Performance vendeurs
                _VendeurStatsCard(month: month, year: year),

                const SizedBox(height: 10),

                // Evolution paiements
                _DailyPaymentsCard(month: month, year: year),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final IconData icon;
  final LinearGradient iconGradient;
  final String title;
  final Widget child;
  final double height;

  const _ChartCard({
    required this.icon,
    required this.iconGradient,
    required this.title,
    required this.child,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: iconGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 13, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(title, style: AppTextStyles.titleMedium),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            height: height,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _TopClientsCard extends ConsumerWidget {
  final int month;
  final int year;

  const _TopClientsCard({required this.month, required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topAsync = ref.watch(topClientsProvider);

    return _ChartCard(
      icon: Icons.people_outline,
      iconGradient: AppGradients.brand,
      title: 'Top 5 Clients',
      child: topAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(
                color: AppColors.accent, strokeWidth: 2)),
        error: (e, _) => EmptyState(
            icon: Icons.error_outline, message: 'Erreur', iconColor: AppColors.danger),
        data: (top) {
          if (top.isEmpty) {
            return const EmptyState(
                icon: Icons.people_outline,
                message: 'Aucune donnee ce mois');
          }
          final maxVal =
          top.map((c) => c.montantTotal).reduce((a, b) => a > b ? a : b);
          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxVal * 1.2,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i < 0 || i >= top.length) return const SizedBox();
                      final name = top[i].nomClient.split(' ').first;
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          name.length > 6
                              ? '${name.substring(0, 6)}.'
                              : name,
                          style: AppTextStyles.caption,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (v, _) => Text(
                      v >= 1000
                          ? '${(v / 1000).toStringAsFixed(0)}k'
                          : v.toStringAsFixed(0),
                      style: AppTextStyles.caption,
                    ),
                  ),
                ),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.border,
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              barGroups: top.asMap().entries.map((e) {
                final hue = 190.0 + e.key * 35;
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.montantTotal,
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          HSLColor.fromAHSL(0.75, hue, 0.8, 0.62)
                              .toColor(),
                          HSLColor.fromAHSL(0.5, hue + 20, 0.8, 0.72)
                              .toColor(),
                        ],
                      ),
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6)),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _TopProductsCard extends ConsumerWidget {
  final int month;
  final int year;

  const _TopProductsCard({required this.month, required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topAsync = ref.watch(topProductsProvider);

    return _ChartCard(
      icon: Icons.inventory_2_outlined,
      iconGradient: AppGradients.rose,
      title: 'Top 5 Produits',
      child: topAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(
                color: AppColors.accent, strokeWidth: 2)),
        error: (e, _) => EmptyState(
            icon: Icons.error_outline, message: 'Erreur', iconColor: AppColors.danger),
        data: (top) {
          if (top.isEmpty) {
            return const EmptyState(
                icon: Icons.inventory_2_outlined,
                message: 'Aucune donnee ce mois');
          }
          final total =
          top.fold(0.0, (s, p) => s + p.montantTotal);
          return PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: top.asMap().entries.map((e) {
                final colors = [
                  AppColors.accent,
                  AppColors.danger,
                  AppColors.warning,
                  AppColors.success,
                  AppColors.purple,
                ];
                final pct = total > 0
                    ? (e.value.montantTotal / total * 100)
                    : 0.0;
                return PieChartSectionData(
                  value: e.value.montantTotal,
                  title: '${pct.toStringAsFixed(0)}%',
                  color: colors[e.key % colors.length].withOpacity(0.75),
                  radius: 60,
                  titleStyle: AppTextStyles.caption
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _RepartitionCard extends ConsumerWidget {
  final int month;
  final int year;

  const _RepartitionCard({required this.month, required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repAsync = ref.watch(repartitionDettesProvider);

    return _ChartCard(
      icon: Icons.pie_chart_outline,
      iconGradient: AppGradients.green,
      title: 'Repartition des dettes',
      child: repAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(
                color: AppColors.accent, strokeWidth: 2)),
        error: (_, __) => const EmptyState(
            icon: Icons.error_outline, message: 'Erreur'),
        data: (rep) {
          final total = rep.actives + rep.partielles + rep.payees;
          if (total == 0) {
            return const EmptyState(
                icon: Icons.pie_chart_outline,
                message: 'Aucune donnee ce mois');
          }
          return Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: [
                      if (rep.actives > 0)
                        PieChartSectionData(
                          value: rep.actives.toDouble(),
                          title: '${rep.actives}',
                          color: AppColors.danger.withOpacity(0.75),
                          radius: 60,
                          titleStyle: AppTextStyles.caption
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      if (rep.partielles > 0)
                        PieChartSectionData(
                          value: rep.partielles.toDouble(),
                          title: '${rep.partielles}',
                          color: AppColors.warning.withOpacity(0.75),
                          radius: 60,
                          titleStyle: AppTextStyles.caption
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      if (rep.payees > 0)
                        PieChartSectionData(
                          value: rep.payees.toDouble(),
                          title: '${rep.payees}',
                          color: AppColors.success.withOpacity(0.75),
                          radius: 60,
                          titleStyle: AppTextStyles.caption
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Legend(
                      color: AppColors.danger,
                      label: 'Actives',
                      count: rep.actives),
                  const SizedBox(height: 8),
                  _Legend(
                      color: AppColors.warning,
                      label: 'Partielles',
                      count: rep.partielles),
                  const SizedBox(height: 8),
                  _Legend(
                      color: AppColors.success,
                      label: 'Payees',
                      count: rep.payees),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _Legend({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($count)',
          style: AppTextStyles.caption.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

class _VendeurStatsCard extends ConsumerWidget {
  final int month;
  final int year;

  const _VendeurStatsCard({required this.month, required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendAsync = ref.watch(vendeurStatsProvider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppGradients.greenLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person_outline,
                    size: 13, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text('Performance vendeurs',
                  style: AppTextStyles.titleMedium),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: vendAsync.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.accent, strokeWidth: 2)),
              error: (_, __) => const EmptyState(
                  icon: Icons.error_outline, message: 'Erreur'),
              data: (vendors) {
                if (vendors.isEmpty) {
                  return const EmptyState(
                      icon: Icons.person_outline,
                      message: 'Aucune donnee ce mois');
                }
                return Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.border)),
                      ),
                      children: [
                        'Utilisateur',
                        'Fac.',
                        'Montant',
                        'Paye',
                      ]
                          .map((h) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(h,
                            style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5)),
                      ))
                          .toList(),
                    ),
                    ...vendors.map(
                          (v) => TableRow(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8),
                            child: Text('@${v.pseudo}',
                                style: AppTextStyles.labelSmall),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8),
                            child: Text('${v.nombreFactures}',
                                style: AppTextStyles.labelSmall),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                                AppFormatters.currencyCompact(
                                    v.montantTotal),
                                style: AppTextStyles.labelSmall),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              AppFormatters.currencyCompact(v.montantPaye),
                              style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyPaymentsCard extends ConsumerWidget {
  final int month;
  final int year;

  const _DailyPaymentsCard({required this.month, required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailyPaymentsProvider);

    return _ChartCard(
      icon: Icons.area_chart_outlined,
      iconGradient: AppGradients.orange,
      title: 'Evolution paiements',
      height: 160,
      child: dailyAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(
                color: AppColors.accent, strokeWidth: 2)),
        error: (_, __) => const EmptyState(
            icon: Icons.error_outline, message: 'Erreur'),
        data: (daily) {
          final maxVal =
          daily.isEmpty ? 1.0 : daily.reduce((a, b) => a > b ? a : b);
          if (maxVal <= 0) {
            return const EmptyState(
                icon: Icons.area_chart_outlined,
                message: 'Aucun paiement ce mois');
          }
          return LineChart(
            LineChartData(
              minX: 0,
              maxX: (daily.length - 1).toDouble(),
              minY: 0,
              maxY: maxVal * 1.2,
              lineTouchData: LineTouchData(enabled: false),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.border,
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (daily.length / 5).roundToDouble(),
                    getTitlesWidget: (v, _) => Text(
                      '${v.toInt() + 1}',
                      style: AppTextStyles.caption,
                    ),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (v, _) => Text(
                      v >= 1000
                          ? '${(v / 1000).toStringAsFixed(0)}k'
                          : v.toStringAsFixed(0),
                      style: AppTextStyles.caption,
                    ),
                  ),
                ),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: daily.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value);
                  }).toList(),
                  isCurved: true,
                  gradient: const LinearGradient(
                    colors: [AppColors.accent, AppColors.purple],
                  ),
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.accent.withOpacity(0.07),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}