import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/user_model.dart';
import '../../core/services/auth_service.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isPending;
  final bool isBanned;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isPending = false,
    this.isBanned = false,
  });

  bool get isAuthenticated => user != null && !isPending && !isBanned;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isPending,
    bool? isBanned,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isPending: isPending ?? this.isPending,
      isBanned: isBanned ?? this.isBanned,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  Future<bool> login(String pseudo, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _authService.login(pseudo, password);
      if (result.isSuccess) {
        state = AuthState(user: result.user);
        return true;
      } else if (result.isPending) {
        state = AuthState(
            user: result.user, isPending: true, error: result.error);
        return false;
      } else if (result.isBanned) {
        state = AuthState(
            user: result.user, isBanned: true, error: result.error);
        return false;
      } else {
        state = state.copyWith(isLoading: false, error: result.error);
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String nomComplet,
    required String pseudo,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _authService.register(
        nomComplet: nomComplet,
        pseudo: pseudo,
        password: password,
      );
      if (!result.isSuccess) {
        state = state.copyWith(isLoading: false, error: result.error);
        return false;
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> createAdmin({
    required String nomComplet,
    required String pseudo,
    required String password,
  }) async {
    if (state.user == null || !state.user!.estSuperuser) return false;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _authService.createAdmin(
        nomComplet: nomComplet,
        pseudo: pseudo,
        password: password,
        createdBy: state.user!,
      );
      state = state.copyWith(isLoading: false);
      return result.isSuccess;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> approveUser(int userId) async {
    if (state.user == null || !state.user!.estAdmin) return;
    await _authService.approveUser(userId, state.user!);
  }

  Future<void> rejectUser(int userId) async {
    if (state.user == null || !state.user!.estAdmin) return;
    await _authService.rejectUser(userId, state.user!);
  }

  Future<void> banUser(int userId) async {
    if (state.user == null || !state.user!.estAdmin) return;
    await _authService.banUser(userId, state.user!);
  }

  Future<void> unbanUser(int userId) async {
    if (state.user == null || !state.user!.estAdmin) return;
    await _authService.unbanUser(userId, state.user!);
  }

  Future<void> permanentlyDeleteUser(int userId) async {
    if (state.user == null || !state.user!.estAdmin) return;
    await _authService.permanentlyDeleteUser(userId, state.user!);
  }

  // Utilisateur banni demande la reactivation
  Future<void> requestReactivation() async {
    if (state.user == null) return;
    await _authService.requestReactivation(state.user!.id);
    state = AuthState(
      user: state.user,
      isPending: true,
      error: 'Demande envoyee. En attente d\'approbation.',
    );
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthNotifier(service);
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final pendingUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(authServiceProvider).getPendingUsers();
});

final approvedUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(authServiceProvider).getApprovedActiveUsers();
});

final bannedUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(authServiceProvider).getBannedUsers();
});