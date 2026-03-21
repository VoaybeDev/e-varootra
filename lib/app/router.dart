import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/home/home_shell.dart';
import '../features/home/pages/home_page.dart';
import '../features/clients/clients_page.dart';
import '../features/products/products_page.dart';
import '../features/debts/debts_page.dart';
import '../features/debts/debt_detail_page.dart';
import '../features/debts/invoice_create_page.dart';
import '../features/archive/archive_page.dart';
import '../features/archive/archive_detail_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/settings/settings_page.dart';

part 'router.g.dart';

// Routes nommées
abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String homeTab = '/home/:tab';
  static const String clients = '/home/clients';
  static const String products = '/home/products';
  static const String debts = '/home/debts';
  static const String debtDetail = '/home/debts/:clientId';
  static const String invoiceCreate = '/home/debts/create';
  static const String archive = '/home/archive';
  static const String archiveDetail = '/home/archive/:clientId';
  static const String dashboard = '/home/dashboard';
  static const String settings = '/settings';
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),

      // Shell principal avec bottom navigation
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          // Accueil
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),

          // Clients
          GoRoute(
            path: AppRoutes.clients,
            name: 'clients',
            builder: (context, state) => const ClientsPage(),
          ),

          // Produits
          GoRoute(
            path: AppRoutes.products,
            name: 'products',
            builder: (context, state) => const ProductsPage(),
          ),

          // Dettes - liste clients
          GoRoute(
            path: AppRoutes.debts,
            name: 'debts',
            builder: (context, state) => const DebtsPage(),
            routes: [
              // Creation facture
              GoRoute(
                path: 'create',
                name: 'invoice-create',
                builder: (context, state) {
                  final clientId = state.uri.queryParameters['clientId'];
                  return InvoiceCreatePage(
                    preselectedClientId:
                    clientId != null ? int.tryParse(clientId) : null,
                  );
                },
              ),

              // Detail dettes d'un client
              GoRoute(
                path: ':clientId',
                name: 'debt-detail',
                builder: (context, state) {
                  final clientId = int.parse(state.pathParameters['clientId']!);
                  return DebtDetailPage(clientId: clientId);
                },
              ),
            ],
          ),

          // Archive - liste clients archivés
          GoRoute(
            path: AppRoutes.archive,
            name: 'archive',
            builder: (context, state) => const ArchivePage(),
            routes: [
              // Detail archive d'un client
              GoRoute(
                path: ':clientId',
                name: 'archive-detail',
                builder: (context, state) {
                  final clientId = int.parse(state.pathParameters['clientId']!);
                  return ArchiveDetailPage(clientId: clientId);
                },
              ),
            ],
          ),

          // Dashboard
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
        ],
      ),

      // Paramètres (hors shell)
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],

    // Redirection globale en cas d'erreur 404
    errorBuilder: (context, state) => const SplashScreen(),
  );
}