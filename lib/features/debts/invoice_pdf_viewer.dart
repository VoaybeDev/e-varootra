import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/models/invoice_model.dart';
import '../../core/services/pdf_service.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';

class InvoicePdfViewer extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoicePdfViewer({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        backgroundColor: AppColors.headerBg,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.textMuted),
        ),
        title: GradientText(
          invoice.numeroFacture,
          gradient: AppGradients.brand,
          style: AppTextStyles.headlineSmall,
        ),
        actions: [
          // Partager
          GestureDetector(
            onTap: () async {
              try {
                await PdfService.shareInvoice(context, invoice);
              } catch (e) {
                if (context.mounted) {
                  AppToast.show(context, 'Erreur partage : $e',
                      type: ToastType.error);
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.share_outlined,
                  color: AppColors.textMuted, size: 20),
            ),
          ),
          // Imprimer
          GestureDetector(
            onTap: () async {
              try {
                await PdfService.printInvoice(context, invoice);
              } catch (e) {
                if (context.mounted) {
                  AppToast.show(context, 'Erreur impression : $e',
                      type: ToastType.error);
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.print_outlined,
                  color: AppColors.textMuted, size: 20),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Apercu PDF
          Expanded(
            child: PdfPreview(
              build: (_) => PdfService.generateInvoicePdf(invoice),
              allowPrinting: true,
              allowSharing: true,
              canChangePageFormat: false,
              canDebug: false,
              pdfFileName: '${invoice.numeroFacture}.pdf',
              loadingWidget: const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
              scrollViewDecoration: const BoxDecoration(
                color: AppColors.bgDeep,
              ),
            ),
          ),

          // Boutons action
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: const BoxDecoration(
              color: AppColors.navBg,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    label: 'Partager',
                    icon: Icons.share_outlined,
                    onPressed: () => PdfService.shareInvoice(context, invoice),
                    gradient: AppGradients.brand,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    label: 'Imprimer',
                    icon: Icons.print_outlined,
                    onPressed: () =>
                        PdfService.printInvoice(context, invoice),
                    gradient: AppGradients.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}