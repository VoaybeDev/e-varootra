# E-VAROOTRA

> Application mobile de gestion de ventes a credit - Flutter · Dart · Riverpod · Drift

---

## Apercu

**E-VAROOTRA** est une application mobile destinee aux commercants malgaches pour gerer leurs ventes a credit. Elle permet de creer des factures, suivre les dettes clients, enregistrer des paiements et analyser l'activite via des tableaux de bord.

- Langue interface : Francais
- Monnaie : Ariary (Ar)
- Mode : Dark premium mobile-first
- Plateforme cible : Android (iOS compatible)

---

## Stack technique

| Couche | Technologie |
|---|---|
| Framework | Flutter 3.22+ |
| Langage | Dart 3.3+ |
| State management | Riverpod 2.5 |
| Navigation | go_router 14 |
| Base de donnees | Drift + SQLite |
| Graphiques | fl_chart |
| PDF / Impression | pdf + printing |
| Typographie | Google Fonts (Syne + DM Sans) |

---

## Prerequis

Avant de lancer le projet, verifie que tu as :

```bash
# Flutter SDK >= 3.22
flutter --version

# Dart SDK >= 3.3
dart --version

# Verifier les dependances Flutter
flutter doctor
```

Un emulateur Android ou un appareil physique connecte est requis.

---

## Installation

```bash
# 1. Cloner le depot
git clone https://github.com/VoaybeDev/e-varootra.git
cd e-varootra

# 2. Installer les dependances
flutter pub get

# 3. Generer les fichiers Drift et Riverpod
dart run build_runner build --delete-conflicting-outputs

# 4. Lancer l'application en mode debug
flutter run
```

---

## Structure du projet

```
lib/
  main.dart                    # Point d'entree
  app/
    app.dart                   # Widget racine
    router.dart                # Navigation go_router
    theme/
      app_colors.dart          # Palette de couleurs
      app_gradients.dart       # Gradients
      app_text_styles.dart     # Styles typographiques
      app_theme.dart           # Theme Material
    utils/
      constants.dart           # Constantes globales
      formatters.dart          # Formatage montants / dates
      validators.dart          # Validation formulaires
      helpers.dart             # Fonctions utilitaires
      intl_init.dart           # Initialisation dates fr_FR
  core/
    database/
      app_database.dart        # Base de donnees Drift
      tables/                  # Definition des tables
      daos/                    # Data Access Objects
    models/                    # Modeles de donnees
    services/
      auth_service.dart        # Authentification
      invoice_service.dart     # Gestion factures
      payment_service.dart     # Gestion paiements
      stats_service.dart       # Statistiques
      pdf_service.dart         # Export PDF
    widgets/                   # Composants reutilisables
  features/
    splash/                    # Ecran de demarrage
    onboarding/                # 3 slides d'introduction
    auth/                      # Connexion / Inscription
    home/                      # Accueil + statistiques mensuelles
    clients/                   # CRUD clients
    products/                  # CRUD produits + historique prix
    debts/                     # Dettes + creation facture + paiement
    archive/                   # Factures payees (lecture seule)
    dashboard/                 # Graphiques et analyses
    settings/                  # Parametres utilisateur
assets/
  images/                      # Images et icones
```

---

## Modele de donnees

Le schema SQLite contient 8 tables :

```
Users          - Utilisateurs de l'application
Clients        - Clients du commerce
Products       - Catalogue produits
Units          - Unites de mesure (kg, L, sac...)
ProductUnits   - Combinaison produit + unite + prix
PriceHistory   - Historique des changements de prix
Debts          - Lignes de dette (une ligne par produit par facture)
Payments       - Historique des paiements
```

---

## Regles metier importantes

- Une facture ne peut jamais etre supprimee
- Une facture totalement payee passe automatiquement en Archive
- Le prix est fige au moment de la creation de la facture
- Un changement de prix futur n'affecte jamais les anciennes factures
- Impossible de supprimer un client ayant des dettes non soldees
- Impossible de payer plus que le montant restant
- La date d'une facture ne peut pas etre dans le futur
- La navigation mensuelle ne depasse jamais le mois actuel
- Les paiements sont distribues proportionnellement sur les lignes de la facture

---

## Ecrans

| Ecran | Description |
|---|---|
| Splash | Animation de demarrage avec logo |
| Onboarding | 3 slides de presentation |
| Auth | Connexion et inscription avec onglets |
| Accueil | Stats mensuelles + resume financier |
| Clients | Liste, recherche, ajout, modification, suppression douce |
| Produits | Catalogue, unites, prix, historique des changements |
| Dettes | Liste clients debiteurs, detail factures, paiement |
| Creation facture | Formulaire multi-lignes avec paiement initial |
| Paiement | Sheet avec boutons rapides 1/3, 1/2, total |
| Archive | Factures payees en lecture seule |
| Dashboard | Graphiques top clients, top produits, repartition, evolution |
| Parametres | Profil, navigation, deconnexion |

---

## Compte de demonstration

Au premier lancement, un compte admin est cree automatiquement :

```
Pseudo       : admin
Mot de passe : 1234
```

---

## Format numero de facture

```
FAC-AAAA-NNN
Exemple : FAC-2026-001
```

L'increment est annuel. Chaque nouvelle annee repart de 001.

---

## Generation de code (Drift + Riverpod)

Apres toute modification des tables Drift ou des providers annotes :

```bash
dart run build_runner build --delete-conflicting-outputs
```

Pour surveiller les changements en continu :

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Build de production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (recommande Play Store)
flutter build appbundle --release

# iOS (requiert macOS + Xcode)
flutter build ios --release
```

---

## Analyse et qualite

```bash
# Analyser le code
flutter analyze

# Lancer les tests
flutter test
```

---

## Troubleshooting

**Erreur build_runner**
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Erreur de dependances**
```bash
flutter clean
flutter pub get
```

**Base de donnees corrompue (dev)**
```bash
# Desinstaller l'app sur l'emulateur puis relancer
flutter run
```

**Erreur custom_lint version**
```bash
flutter pub add dev:custom_lint:'^0.7.6'
flutter pub add dev:riverpod_lint:'^2.6.5'
flutter pub get
```

---

## Contributeurs

- **VoaybeDev** - Developpeur principal

---

## Licence

Projet prive - Tous droits reserves 2026 VoaybeDev