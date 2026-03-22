import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import 'constants.dart';

abstract class AppHelpers {
  // Gradient avatar selon index
  static LinearGradient avatarGradient(int index) {
    return AppGradients.avatarAt(index);
  }

  // Couleur statut
  static Color statusColor(String status) {
    switch (status) {
      case AppConstants.statusActive:
        return AppColors.danger;
      case AppConstants.statusPartial:
        return AppColors.warning;
      case AppConstants.statusPaid:
        return AppColors.success;
      default:
        return AppColors.textMuted;
    }
  }

  // Background badge statut
  static Color statusBadgeBg(String status) {
    switch (status) {
      case AppConstants.statusActive:
        return AppColors.badgeDangerBg;
      case AppConstants.statusPartial:
        return AppColors.badgeWarningBg;
      case AppConstants.statusPaid:
        return AppColors.badgeSuccessBg;
      default:
        return AppColors.bgCard;
    }
  }

  // Bordure badge statut
  static Color statusBadgeBorder(String status) {
    switch (status) {
      case AppConstants.statusActive:
        return AppColors.badgeDangerBorder;
      case AppConstants.statusPartial:
        return AppColors.badgeWarningBorder;
      case AppConstants.statusPaid:
        return AppColors.badgeSuccessBorder;
      default:
        return AppColors.border;
    }
  }

  // Calcul statut depuis montants
  static String computeStatus({
    required double total,
    required double paid,
  }) {
    if (total <= 0) return AppConstants.statusActive;
    final remaining = total - paid;
    if (remaining <= 0) return AppConstants.statusPaid;
    if (paid > 0) return AppConstants.statusPartial;
    return AppConstants.statusActive;
  }

  // Calcul restant
  static double computeRemaining(double total, double paid) {
    return (total - paid).clamp(0.0, double.infinity);
  }

  // Taux de recouvrement
  static double recoveryRate(double totalCreated, double totalPaid) {
    if (totalCreated <= 0) return 0.0;
    return ((totalPaid / totalCreated) * 100).clamp(0.0, 100.0);
  }

  // Taux de dettes soldees
  static double paidRate(int totalCount, int paidCount) {
    if (totalCount <= 0) return 0.0;
    return ((paidCount / totalCount) * 100).clamp(0.0, 100.0);
  }

  // Moyenne par dette
  static double averageDebt(double totalAmount, int count) {
    if (count <= 0) return 0.0;
    return totalAmount / count;
  }

  // Verifier si le mois est le mois actuel
  static bool isCurrentMonth(int month, int year) {
    final now = DateTime.now();
    return month == now.month && year == now.year;
  }

  // Verifier si on peut aller au mois suivant
  static bool canGoNextMonth(int month, int year) {
    final now = DateTime.now();
    if (year > now.year) return false;
    if (year == now.year && month >= now.month) return false;
    return true;
  }

  // Naviguer au mois precedent
  static (int month, int year) previousMonth(int month, int year) {
    if (month == 1) return (12, year - 1);
    return (month - 1, year);
  }

  // Naviguer au mois suivant
  static (int month, int year) nextMonth(int month, int year) {
    if (month == 12) return (1, year + 1);
    return (month + 1, year);
  }

  // Nombre de jours dans un mois
  static int daysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  // Prefix iso du mois : 2026-03
  static String monthPrefix(int month, int year) {
    return '$year-${month.toString().padLeft(2, '0')}';
  }

  // Supprimer les accents d'une chaine
  static String removeAccents(String input) {
    const accents = 'àâäéèêëîïôöùûüç';
    const replacements = 'aaaeeeeiioouuuc';
    String result = input.toLowerCase();
    for (int i = 0; i < accents.length; i++) {
      result = result.replaceAll(accents[i], replacements[i]);
    }
    return result;
  }

  // Nettoyer une chaine pour reference
  static String cleanForRef(String input) {
    return removeAccents(input)
        .replaceAll(RegExp(r'[^a-z0-9]'), '')
        .toUpperCase();
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

  // Afficher un dialog de confirmation
  static Future<bool> confirmDialog(
      BuildContext context, {
        required String title,
        required String message,
        String confirmLabel = 'Confirmer',
        String cancelLabel = 'Annuler',
        bool isDangerous = false,
      }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF10182A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              cancelLabel,
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmLabel,
              style: TextStyle(
                color: isDangerous ? AppColors.danger : AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}