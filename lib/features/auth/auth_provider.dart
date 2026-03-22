import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/user_model.dart';
import '../../core/services/auth_service.dart';

// Etat de session
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  // Connexion
  Future<bool> login(String pseudo, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.login(pseudo, password);
      if (user == null) {
        state = state.copyWith(isLoading: false, error: 'Identifiants incorrects');
        return false;
      }
      await _authService.saveSession(user.id);
      state = AuthState(user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // Inscription
  Future<bool> register({
    required String nomComplet,
    required String pseudo,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.register(
        nomComplet: nomComplet,
        pseudo: pseudo,
        password: password,
      );
      if (user == null) {
        state = state.copyWith(isLoading: false, error: 'Ce pseudo est deja utilise');
        return false;
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  // Restaurer session
  Future<void> restoreSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final userId = await _authService.getSavedUserId();
      if (userId != null) {
        final user = await _authService.getUserById(userId);
        state = AuthState(user: user);
      } else {
        state = const AuthState();
      }
    } catch (_) {
      state = const AuthState();
    }
  }

// Deconnexion
  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState();
  }

  // Effacer erreur
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthNotifier(service);
});

// Provider utilisateur courant
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});