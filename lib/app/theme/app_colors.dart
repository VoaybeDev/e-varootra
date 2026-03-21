import 'package:flutter/material.dart';

abstract class AppColors {
  // Fonds
  static const Color bgDeep = Color(0xFF080B14);
  static const Color bgCard = Color.fromRGBO(255, 255, 255, 0.04);
  static const Color bgCardHover = Color.fromRGBO(255, 255, 255, 0.08);

  // Bordures
  static const Color border = Color.fromRGBO(255, 255, 255, 0.08);
  static const Color borderActive = Color.fromRGBO(0, 210, 255, 0.4);

  // Accents
  static const Color accent = Color(0xFF00D2FF);
  static const Color danger = Color(0xFFF7376E);
  static const Color success = Color(0xFF0ABF8A);
  static const Color warning = Color(0xFFF7C948);
  static const Color purple = Color(0xFF7B2FF7);
  static const Color orange = Color(0xFFFF6B35);

  // Textes
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textMuted = Color.fromRGBO(240, 244, 255, 0.5);
  static const Color textFaint = Color.fromRGBO(240, 244, 255, 0.25);

  // Statuts badge
  static const Color badgeSuccessBg = Color.fromRGBO(10, 191, 138, 0.12);
  static const Color badgeSuccessBorder = Color.fromRGBO(10, 191, 138, 0.2);
  static const Color badgeWarningBg = Color.fromRGBO(247, 201, 72, 0.12);
  static const Color badgeWarningBorder = Color.fromRGBO(247, 201, 72, 0.2);
  static const Color badgeDangerBg = Color.fromRGBO(247, 55, 110, 0.12);
  static const Color badgeDangerBorder = Color.fromRGBO(247, 55, 110, 0.2);
  static const Color badgeAccentBg = Color.fromRGBO(0, 210, 255, 0.12);
  static const Color badgeAccentBorder = Color.fromRGBO(0, 210, 255, 0.2);

  // Overlay
  static const Color overlay = Color.fromRGBO(0, 0, 0, 0.75);
  static const Color sheetBg = Color(0xFF10182A);
  static const Color sheetBg2 = Color(0xFF0A1020);

  // Header
  static const Color headerBg = Color.fromRGBO(8, 11, 20, 0.9);

  // Bottom nav
  static const Color navBg = Color.fromRGBO(8, 11, 20, 0.95);

  // Input
  static const Color inputBg = Color.fromRGBO(255, 255, 255, 0.06);
  static const Color inputFocusBg = Color.fromRGBO(0, 210, 255, 0.05);

  // Transparent
  static const Color transparent = Colors.transparent;
}