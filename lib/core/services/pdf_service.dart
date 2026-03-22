import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/invoice_model.dart';
import '../../app/utils/formatters.dart';

class PdfService {
  // Generer le PDF d'une facture
  static Future<Uint8List> generateInvoicePdf(InvoiceModel invoice) async {
    final pdf = pw.Document();

    // Couleurs
    const brandBlue = PdfColor.fromInt(0xFF00D2FF);
    const darkBg = PdfColor.fromInt(0xFF0A1020);
    const textDark = PdfColor.fromInt(0xFF111111);
    const textGray = PdfColor.fromInt(0xFF666666);
    const lineColor = PdfColor.fromInt(0xFFDDDDDD);
    const successGreen = PdfColor.fromInt(0xFF0ABF8A);
    const warningOrange = PdfColor.fromInt(0xFFD97706);
    const dangerRed = PdfColor.fromInt(0xFFF7376E);

    final statusColor = invoice.estPayee
        ? successGreen
        : invoice.estPartielle
        ? warningOrange
        : dangerRed;

    final statusText = invoice.estPayee
        ? 'DETTE TOTALEMENT PAYEE'
        : invoice.estPartielle
        ? 'PAIEMENT PARTIEL - Restant : ${AppFormatters.currency(invoice.montantRestant)}'
        : 'NON PAYEE - Restant : ${AppFormatters.currency(invoice.montantRestant)}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          // En-tete
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 12),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: lineColor, width: 2),
              ),
            ),
            child: pw.Column(
              children: [
                pw.Text(
                  'E-VAROOTRA',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: textDark,
                    letterSpacing: 2,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Gestion des ventes & dettes',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: textGray,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 14),

          // Numero facture
          pw.Center(
            child: pw.Text(
              'FACTURE N ${invoice.numeroFacture}',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: brandBlue,
              ),
            ),
          ),

          pw.SizedBox(height: 14),

          // Meta - date et client
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Date',
                        style: pw.TextStyle(
                            fontSize: 8,
                            color: textGray,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      AppFormatters.dateShort(invoice.dateDette),
                      style: pw.TextStyle(
                          fontSize: 11, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('Vendeur',
                        style: pw.TextStyle(
                            fontSize: 8,
                            color: textGray,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      invoice.nomVendeur,
                      style: pw.TextStyle(
                          fontSize: 11, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Client',
                        style: pw.TextStyle(
                            fontSize: 8,
                            color: textGray,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      invoice.nomClient,
                      style: pw.TextStyle(
                          fontSize: 11, fontWeight: pw.FontWeight.bold),
                    ),
                    if (invoice.telephoneClient.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(
                        invoice.telephoneClient,
                        style: pw.TextStyle(fontSize: 9, color: textGray),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 16),

          // Tableau produits
          pw.Table(
            border: pw.TableBorder(
              bottom: const pw.BorderSide(color: lineColor, width: 1),
              horizontalInside:
              const pw.BorderSide(color: lineColor, width: 0.5),
            ),
            columnWidths: const {
              0: pw.FixedColumnWidth(20),
              1: pw.FlexColumnWidth(3),
              2: pw.FlexColumnWidth(1.5),
              3: pw.FixedColumnWidth(40),
              4: pw.FlexColumnWidth(2),
              5: pw.FlexColumnWidth(2),
            },
            children: [
              // Header tableau
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFF5F5F5),
                ),
                children: ['#', 'Produit', 'Unite', 'Qte', 'Prix U.', 'Total']
                    .map(
                      (h) => pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 4, vertical: 5),
                    child: pw.Text(
                      h,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: textGray,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),

              // Lignes produits
              ...invoice.lignes.asMap().entries.map(
                    (e) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: pw.Text(
                        '${e.key + 1}',
                        style: pw.TextStyle(fontSize: 9, color: textGray),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: pw.Text(
                        e.value.nomProduit ?? '-',
                        style: pw.TextStyle(fontSize: 9),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: pw.Text(
                        e.value.nomUnite ?? '-',
                        style: pw.TextStyle(fontSize: 9, color: textGray),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: pw.Text(
                        e.value.quantite
                            .toStringAsFixed(e.value.quantite % 1 == 0 ? 0 : 1),
                        style: pw.TextStyle(
                            fontSize: 9, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: pw.Text(
                        AppFormatters.currency(e.value.prixUnitaireFige),
                        style: pw.TextStyle(fontSize: 9),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: pw.Text(
                        AppFormatters.currency(e.value.montantTotal),
                        style: pw.TextStyle(
                            fontSize: 9, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 12),

          // Totaux
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: textDark, width: 2),
              ),
            ),
            padding: const pw.EdgeInsets.only(top: 8),
            child: pw.Column(
              children: [
                _pdfTotalRow('Sous-total',
                    AppFormatters.currency(invoice.montantTotal), false),
                _pdfTotalRow(
                    'Remise', '0 Ar', false),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 4),
                  padding: const pw.EdgeInsets.only(top: 6),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(color: textDark, width: 2),
                    ),
                  ),
                  child: _pdfTotalRow(
                    'TOTAL',
                    AppFormatters.currency(invoice.montantTotal),
                    true,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 12),

          // Statut
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            decoration: pw.BoxDecoration(
              color: statusColor.shade(0.9),
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: statusColor, width: 1),
            ),
            child: pw.Center(
              child: pw.Text(
                statusText,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: statusColor,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ),

          // Historique paiements
          if (invoice.paiements.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: const PdfColor.fromInt(0xFFF9F9F9),
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(
                    color: const PdfColor.fromInt(0xFFEEEEEE)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Historique des paiements',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: textGray,
                      letterSpacing: 0.5,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  ...invoice.paiements.map(
                        (p) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                AppFormatters.dateShort(p.datePaiement),
                                style: pw.TextStyle(
                                    fontSize: 9, color: textGray),
                              ),
                              pw.Text(
                                'Ref: ${p.referencePaiement}',
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    color: const PdfColor.fromInt(0xFF999999)),
                              ),
                            ],
                          ),
                          pw.Text(
                            '+${AppFormatters.currency(p.montantPaye)}',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          pw.SizedBox(height: 16),

          // Signatures
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Signature vendeur : ____________',
                  style: pw.TextStyle(fontSize: 9, color: textGray)),
              pw.Text('Signature client : ____________',
                  style: pw.TextStyle(fontSize: 9, color: textGray)),
            ],
          ),

          pw.SizedBox(height: 12),

          // Pied de page
          pw.Center(
            child: pw.Text(
              'Merci de votre confiance !',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: textGray,
              ),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _pdfTotalRow(
      String label, String value, bool isBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isBold ? 13 : 11,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isBold ? 13 : 11,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Partager le PDF
  static Future<void> shareInvoice(
      BuildContext context, InvoiceModel invoice) async {
    final bytes = await generateInvoicePdf(invoice);
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${invoice.numeroFacture}.pdf',
    );
  }

  // Imprimer le PDF
  static Future<void> printInvoice(
      BuildContext context, InvoiceModel invoice) async {
    final bytes = await generateInvoicePdf(invoice);
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: invoice.numeroFacture,
    );
  }

  // Apercu du PDF
  static Future<void> previewInvoice(
      BuildContext context, InvoiceModel invoice) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: const Color(0xFF080B14),
          appBar: AppBar(
            backgroundColor: const Color(0xFF080B14),
            title: Text(invoice.numeroFacture),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => shareInvoice(context, invoice),
              ),
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: () => printInvoice(context, invoice),
              ),
            ],
          ),
          body: PdfPreview(
            build: (_) => generateInvoicePdf(invoice),
            allowPrinting: true,
            allowSharing: true,
            canChangePageFormat: false,
            pdfFileName: '${invoice.numeroFacture}.pdf',
          ),
        ),
      ),
    );
  }
}