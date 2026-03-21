import 'package:flutter/material.dart';

abstract class AppGradients {
  // Brand - cyan vers violet
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D2FF), Color(0xFF7B2FF7)],
  );

  // Orange - orange vers jaune
  static const LinearGradient orange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFF7C948)],
  );

  // Rose - rose vers orange
  static const LinearGradient rose = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7376E), Color(0xFFFF9D6C)],
  );

  // Green - vert vers cyan
  static const LinearGradient green = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0ABF8A), Color(0xFF00D2FF)],
  );

  // Blue - bleu vers cyan
  static const LinearGradient blue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A78E5), Color(0xFF00D2FF)],
  );

  // Violet - violet vers rose
  static const LinearGradient violet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7B2FF7), Color(0xFFE040FB)],
  );

  // Vert clair
  static const LinearGradient greenLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0ABF8A), Color(0xFFA8FF78)],
  );

  // Background splash
  static const RadialGradient splashBg = RadialGradient(
    center: Alignment(0, -0.5),
    radius: 1.2,
    colors: [Color(0xFF0D1F44), Color(0xFF080B14)],
  );

  // Background auth
  static const RadialGradient authBg = RadialGradient(
    center: Alignment(0, -0.6),
    radius: 1.2,
    colors: [Color(0xFF0D1F44), Color(0xFF080B14)],
  );

  // Card accentuée
  static const LinearGradient cardAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(0, 210, 255, 0.06),
      Color.fromRGBO(123, 47, 247, 0.08),
    ],
  );

  // Total facture
  static const LinearGradient invoiceTotal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(0, 210, 255, 0.07),
      Color.fromRGBO(123, 47, 247, 0.07),
    ],
  );

  // Paiement section
  static const LinearGradient paySection = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(10, 191, 138, 0.05),
      Color.fromRGBO(10, 191, 138, 0.02),
    ],
  );

  // Sheet bottom
  static const LinearGradient sheet = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF10182A), Color(0xFF0A1020)],
  );

  // Liste des gradients pour les avatars (rotation par index)
  static const List<LinearGradient> avatars = [
    brand,
    orange,
    rose,
    green,
    violet,
  ];

  static LinearGradient avatarAt(int index) {
    return avatars[index % avatars.length];
  }
}