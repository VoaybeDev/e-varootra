import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/models/client_model.dart';
import '../../core/models/invoice_model.dart';
import '../../core/models/payment_model.dart';
import '../../core/services/invoice_service.dart';
import '../../core/services/payment_service.dart';

// Etat du mois selectionne
class SelectedMonthState {
  final int month;
  final int year;

  const SelectedMonthState({required this.month, required this.year});

  SelectedMonthState copyWith({int? month, int? year}) {
    return SelectedMonthState(
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}

class SelectedMonthNotifier extends StateNotifier<SelectedMonthState> {
  SelectedMonthNotifier()
      : super(SelectedMonthState(
    month: DateTime.now().month,
    year: DateTime.now().year,
  ));

  void previous() {
    int m = state.month - 1;
    int y = state.year;
    if (m < 1) {
      m = 12;
      y--;
    }
    state = state.copyWith(month: m, year: y);
  }

  void next() {
    final now = DateTime.now();
    int m = state.month + 1;
    int y = state.year;
    if (m > 12) {
      m = 1;
      y++;
    }
    if (y > now.year || (y == now.year && m > now.month)) return;
    state = state.copyWith(month: m, year: y);
  }

  bool get canGoNext {
    final now = DateTime.now();
    return !(state.year == now.year && state.month >= now.month);
  }
}

final selectedMonthProvider =
StateNotifierProvider<SelectedMonthNotifier, SelectedMonthState>((ref) {
  return SelectedMonthNotifier();
});

// Map client -> factures actives
final activeInvoicesByClientProvider =
FutureProvider<Map<ClientModel, List<InvoiceModel>>>((ref) async {
  final service = ref.watch(invoiceServiceProvider);
  return service.getActiveInvoicesByClient();
});

// Recherche dettes
final debtsSearchProvider = StateProvider<String>((ref) => '');

// Tri dettes
enum DebtSortMode { dateDesc, dateAsc, montantDesc, montantAsc, restantDesc }

final debtSortProvider = StateProvider<DebtSortMode>((ref) => DebtSortMode.dateDesc);

// Factures d'un client (dettes actives)
final clientInvoicesProvider =
FutureProvider.family<List<InvoiceModel>, int>((ref, clientId) async {
  final db = ref.watch(appDatabaseProvider);
  final debts = await db.debtDao.getClientActiveDebts(clientId);

  final Map<String, List<dynamic>> byFacture = {};
  for (final d in debts) {
    byFacture.putIfAbsent(d.numeroFacture, () => []).add(d);
  }

  final service = ref.watch(invoiceServiceProvider);
  final invoices = <InvoiceModel>[];
  for (final num in byFacture.keys) {
    final inv = await service.getInvoice(num);
    if (inv != null) invoices.add(inv);
  }

  invoices.sort((a, b) => b.dateDette.compareTo(a.dateDette));
  return invoices;
});

// Paiements d'une dette
final debtPaymentsProvider =
FutureProvider.family<List<PaymentModel>, int>((ref, detteId) async {
  final service = ref.watch(paymentServiceProvider);
  return service.getPaymentsForDebt(detteId);
});

// Detail d'une facture
final invoiceDetailProvider =
FutureProvider.family<InvoiceModel?, String>((ref, numeroFacture) async {
  final service = ref.watch(invoiceServiceProvider);
  return service.getInvoice(numeroFacture);
});