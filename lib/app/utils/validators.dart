abstract class AppValidators {
  // Nom non vide
  static String? requiredName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis';
    }
    if (value.trim().length < 2) {
      return 'Minimum 2 caracteres';
    }
    return null;
  }

  // Pseudo
  static String? pseudo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le pseudo est requis';
    }
    if (value.trim().length < 3) {
      return 'Minimum 3 caracteres';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'Lettres, chiffres et _ uniquement';
    }
    return null;
  }

  // Mot de passe
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 4) {
      return 'Minimum 4 caracteres';
    }
    return null;
  }

  // Telephone malgache : 034 XX XXX XX (10 chiffres)
  static String? phoneMalagasy(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optionnel
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      return 'Numero invalide (10 chiffres requis)';
    }
    if (!RegExp(r'^0(32|33|34|38)').hasMatch(digits)) {
      return 'Prefixe invalide (032, 033, 034 ou 038)';
    }
    return null;
  }

  // Telephone malgache - validation booleenne
  static bool isValidPhone(String value) {
    if (value.trim().isEmpty) return true;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 && RegExp(r'^0(32|33|34|38)').hasMatch(digits);
  }

  // Montant positif
  static String? positiveAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le montant est requis';
    }
    final n = double.tryParse(value.trim());
    if (n == null) return 'Montant invalide';
    if (n <= 0) return 'Le montant doit etre positif';
    return null;
  }

  // Montant non negatif
  static String? nonNegativeAmount(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final n = double.tryParse(value.trim());
    if (n == null) return 'Montant invalide';
    if (n < 0) return 'Le montant ne peut pas etre negatif';
    return null;
  }

  // Montant max
  static String? Function(String?) maxAmount(double max) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) return null;
      final n = double.tryParse(value.trim());
      if (n == null) return 'Montant invalide';
      if (n > max) return 'Depasse le maximum (${n.toStringAsFixed(0)} > ${max.toStringAsFixed(0)})';
      return null;
    };
  }

  // Quantite positive
  static String? positiveQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La quantite est requise';
    }
    final n = double.tryParse(value.trim());
    if (n == null) return 'Quantite invalide';
    if (n <= 0) return 'La quantite doit etre positive';
    return null;
  }

  // Date non future
  static String? dateNotFuture(DateTime? date) {
    if (date == null) return 'La date est requise';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date.isAfter(today)) return 'La date ne peut pas etre dans le futur';
    return null;
  }

  // Date string non future
  static String? dateStringNotFuture(String? value) {
    if (value == null || value.trim().isEmpty) return 'La date est requise';
    try {
      final date = DateTime.parse(value);
      return dateNotFuture(date);
    } catch (_) {
      return 'Format de date invalide';
    }
  }

  // Description optionnelle avec limite
  static String? optionalDescription(String? value, {int maxLength = 500}) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length > maxLength) {
      return 'Maximum $maxLength caracteres';
    }
    return null;
  }
}