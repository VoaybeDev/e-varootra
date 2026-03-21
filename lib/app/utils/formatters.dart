import 'package:intl/intl.dart';

import 'constants.dart';

abstract class AppFormatters {
  // Format montant : 55 000 Ar
  static String currency(num amount) {
    final formatted = NumberFormat('#,###', 'fr_FR').format(amount);
    return '$formatted ${AppConstants.currency}';
  }

  // Format montant compact : 55k Ar
  static String currencyCompact(num amount) {
    if (amount >= 1000000) {
      final v = (amount / 1000000).toStringAsFixed(1);
      return '${v}M ${AppConstants.currency}';
    }
    if (amount >= 1000) {
      final v = (amount / 1000).toStringAsFixed(0);
      return '${v}k ${AppConstants.currency}';
    }
    return currency(amount);
  }

  // Format nombre seul sans monnaie
  static String number(num value) {
    return NumberFormat('#,###', 'fr_FR').format(value);
  }

  // Format date : 22 mars 2026
  static String dateLong(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'fr_FR').format(date);
  }

  // Format date : 22/03/2026
  static String dateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'fr_FR').format(date);
  }

  // Format date : 2026-03-22 (pour BDD)
  static String dateIso(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format date : 22 mars
  static String dateDayMonth(DateTime date) {
    return DateFormat('dd MMM', 'fr_FR').format(date);
  }

  // Format date depuis string iso
  static String dateFromString(String iso) {
    try {
      final date = DateTime.parse(iso);
      return dateShort(date);
    } catch (_) {
      return iso;
    }
  }

  // Format mois : Janvier 2026
  static String monthYear(int month, int year) {
    if (month < 1 || month > 12) return '-';
    return '${AppConstants.months[month]} $year';
  }

  // Format mois court : Jan 2026
  static String monthYearShort(int month, int year) {
    if (month < 1 || month > 12) return '-';
    return '${AppConstants.monthsShort[month]} $year';
  }

  // Format pourcentage : 76.4%
  static String percent(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  // Format initiales depuis un nom
  static String initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  // Format premier caractere majuscule
  static String firstLetter(String name) {
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  // Format reference paiement
  static String paymentRef(String clientName, DateTime date, int suffix) {
    final first = clientName.trim().split(' ').first;
    final normalized = first
        .toLowerCase()
        .replaceAll(RegExp(r'[àâä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[îï]'), 'i')
        .replaceAll(RegExp(r'[ôö]'), 'o')
        .replaceAll(RegExp(r'[ùûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-z0-9]'), '')
        .toUpperCase();
    final ds = DateFormat('yyyyMMdd').format(date);
    return suffix > 1 ? '$normalized-$ds-$suffix' : '$normalized-$ds';
  }

  // Format numero facture : FAC-2026-001
  static String invoiceNumber(int year, int sequence) {
    final seq = sequence.toString().padLeft(AppConstants.invoiceNumberPadding, '0');
    return '${AppConstants.invoicePrefix}-$year-$seq';
  }

  // Format statut lisible
  static String statusLabel(String status) {
    switch (status) {
      case AppConstants.statusActive:
        return 'Active';
      case AppConstants.statusPartial:
        return 'Partielle';
      case AppConstants.statusPaid:
        return 'Payee';
      default:
        return status;
    }
  }

  // Format performance
  static String performanceLabel(double rate) {
    if (rate >= AppConstants.performanceExcellent) return 'Excellent';
    if (rate >= AppConstants.performanceGood) return 'Bien';
    return 'A ameliorer';
  }

  // Format performance avec emoji
  static String performanceLabelEmoji(double rate) {
    if (rate >= AppConstants.performanceExcellent) return 'Excellent';
    if (rate >= AppConstants.performanceGood) return 'Bien';
    return 'A ameliorer';
  }
}