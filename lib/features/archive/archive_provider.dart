import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/client_model.dart';
import '../../core/models/invoice_model.dart';
import '../../core/services/invoice_service.dart';

// Map client -> factures payees
final paidInvoicesByClientProvider =
FutureProvider<Map<ClientModel, List<InvoiceModel>>>((ref) async {
  final service = ref.watch(invoiceServiceProvider);
  return service.getPaidInvoicesByClient();
});

// Factures payees d'un client
final clientPaidInvoicesProvider =
FutureProvider.family<List<InvoiceModel>, int>((ref, clientId) async {
  final service = ref.watch(invoiceServiceProvider);
  final allPaid = await service.getPaidInvoicesByClient();

  for (final entry in allPaid.entries) {
    if (entry.key.id == clientId) return entry.value;
  }
  return [];
});

// Tri archive
enum ArchiveSortMode { dateDesc, dateAsc, montantDesc, montantAsc }

final archiveSortProvider = StateProvider<ArchiveSortMode>((ref) => ArchiveSortMode.dateDesc);

// Stats archive globales
class ArchiveStats {
  final int nombreFactures;
  final int nombreClients;
  final double totalEncaisse;

  const ArchiveStats({
    required this.nombreFactures,
    required this.nombreClients,
    required this.totalEncaisse,
  });
}

final archiveStatsProvider = FutureProvider<ArchiveStats>((ref) async {
  final allPaid = await ref.watch(paidInvoicesByClientProvider.future);

  int nombreFactures = 0;
  double totalEncaisse = 0;

  for (final invoices in allPaid.values) {
    nombreFactures += invoices.length;
    totalEncaisse += invoices.fold(0.0, (s, inv) => s + inv.montantTotal);
  }

  return ArchiveStats(
    nombreFactures: nombreFactures,
    nombreClients: allPaid.length,
    totalEncaisse: totalEncaisse,
  );
});