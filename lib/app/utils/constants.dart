abstract class AppConstants {
  // App
  static const String appName = 'E-VAROOTRA';
  static const String appTagline = 'Gestion des ventes & dettes';
  static const String appOrg = 'com.voaybedev';
  static const String appVersion = '1.0.0';

  // Monnaie
  static const String currency = 'Ar';
  static const String locale = 'fr_FR';

  // Preferences keys
  static const String prefOnboardingDone = 'onboarding_done';
  static const String prefCurrentUserId = 'current_user_id';
  static const String prefCurrentMonth = 'current_month';
  static const String prefCurrentYear = 'current_year';

  // Format facture
  static const String invoicePrefix = 'FAC';
  static const int invoiceNumberPadding = 3;

  // Modes de paiement
  static const List<String> paymentModes = [
    'Especes',
    'Mobile Money',
    'Virement',
    'Autre',
  ];

  // Validation telephone malgache
  static const List<String> validPhonePrefixes = ['032', '033', '034', '038'];
  static const int phoneLength = 10;

  // Limites UI
  static const int maxProductUnits = 10;
  static const int maxInvoiceLines = 20;
  static const int maxSearchResults = 50;

  // Durations animations
  static const Duration splashDuration = Duration(milliseconds: 2600);
  static const Duration toastDuration = Duration(milliseconds: 3200);
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Tailles
  static const double borderRadius = 16;
  static const double borderRadiusLarge = 24;
  static const double borderRadiusSmall = 10;
  static const double paddingPage = 16;
  static const double paddingCard = 14;
  static const double bottomNavHeight = 62;
  static const double fabSize = 52;
  static const double headerHeight = 56;

  // Seuils performance
  static const double performanceExcellent = 70.0;
  static const double performanceGood = 40.0;

  // Statuts dette
  static const String statusActive = 'active';
  static const String statusPartial = 'partial';
  static const String statusPaid = 'payee';

  // Noms mois
  static const List<String> months = [
    '',
    'Janvier',
    'Fevrier',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Aout',
    'Septembre',
    'Octobre',
    'Novembre',
    'Decembre',
  ];

  static const List<String> monthsShort = [
    '',
    'Jan',
    'Fev',
    'Mar',
    'Avr',
    'Mai',
    'Jun',
    'Jul',
    'Aou',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}