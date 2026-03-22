import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../models/user_model.dart';
import '../../app/utils/constants.dart';

class AuthService {
  final AppDatabase _db;

  AuthService(this._db);

  static String hashPassword(String password) {
    return 'hash_$password';
  }

  // Connexion - verifie approbation
  Future<AuthResult> login(String pseudo, String password) async {
    final hash = hashPassword(password);
    final user = await _db.userDao.authenticate(pseudo, hash);

    if (user == null) {
      return AuthResult.invalidCredentials();
    }
    if (!user.approuve) {
      return AuthResult.pendingApproval(user);
    }
    return AuthResult.success(user);
  }

  // Inscription - cree un utilisateur en attente d'approbation
  Future<RegisterResult> register({
    required String nomComplet,
    required String pseudo,
    required String password,
  }) async {
    final exists = await _db.userDao.pseudoExists(pseudo);
    if (exists) return RegisterResult.pseudoTaken();

    final hash = hashPassword(password);
    final id = await _db.userDao.createUser(
      UsersCompanion.insert(
        nomComplet: nomComplet,
        pseudo: pseudo,
        motDePasseHash: hash,
        role: const Value('utilisateur'),
        approuve: const Value(false),
      ),
    );
    final user = await _db.userDao.getUserById(id);
    return RegisterResult.success(user!);
  }

  // Creer un admin (superuser seulement)
  Future<RegisterResult> createAdmin({
    required String nomComplet,
    required String pseudo,
    required String password,
    required UserModel createdBy,
  }) async {
    if (!createdBy.estSuperuser) {
      return RegisterResult.unauthorized();
    }
    final exists = await _db.userDao.pseudoExists(pseudo);
    if (exists) return RegisterResult.pseudoTaken();

    final hash = hashPassword(password);
    final id = await _db.userDao.createUser(
      UsersCompanion.insert(
        nomComplet: nomComplet,
        pseudo: pseudo,
        motDePasseHash: hash,
        role: const Value('admin'),
        approuve: const Value(true),
      ),
    );
    final user = await _db.userDao.getUserById(id);
    return RegisterResult.success(user!);
  }

  // Approuver un utilisateur (admin ou superuser)
  Future<void> approveUser(int userId, UserModel approvedBy) async {
    if (!approvedBy.estAdmin) return;
    await _db.userDao.approveUser(userId);
  }

  // Rejeter un utilisateur
  Future<void> rejectUser(int userId, UserModel rejectedBy) async {
    if (!rejectedBy.estAdmin) return;
    await _db.userDao.rejectUser(userId);
  }

  // Liste utilisateurs en attente
  Future<List<UserModel>> getPendingUsers() async {
    return _db.userDao.getPendingUsers();
  }

  // Liste tous les utilisateurs approuves
  Future<List<UserModel>> getApprovedUsers() async {
    return _db.userDao.getApprovedUsers();
  }

  Future<UserModel?> getUserById(int id) async {
    return _db.userDao.getUserById(id);
  }

  // Ne plus sauvegarder la session - auth obligatoire a chaque demarrage
  Future<void> saveSession(int userId) async {
    // Session desactivee - l'utilisateur doit se reconnecter a chaque fois
  }

  Future<int?> getSavedUserId() async {
    // Toujours retourner null pour forcer l'auth
    return null;
  }

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefOnboardingDone) ?? false;
  }

  Future<void> markOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefOnboardingDone, true);
  }

  Future<void> logout() async {
    // Rien a nettoyer puisque pas de session sauvegardee
  }
}

// Resultats d'authentification
class AuthResult {
  final UserModel? user;
  final String? error;
  final bool isPending;
  final bool isSuccess;

  const AuthResult._({
    this.user,
    this.error,
    this.isPending = false,
    this.isSuccess = false,
  });

  factory AuthResult.success(UserModel user) =>
      AuthResult._(user: user, isSuccess: true);

  factory AuthResult.invalidCredentials() =>
      AuthResult._(error: 'Identifiants incorrects');

  factory AuthResult.pendingApproval(UserModel user) =>
      AuthResult._(user: user, isPending: true,
          error: 'Compte en attente d\'approbation par un administrateur');
}

// Resultats d'inscription
class RegisterResult {
  final UserModel? user;
  final String? error;
  final bool isSuccess;

  const RegisterResult._({
    this.user,
    this.error,
    this.isSuccess = false,
  });

  factory RegisterResult.success(UserModel user) =>
      RegisterResult._(user: user, isSuccess: true);

  factory RegisterResult.pseudoTaken() =>
      RegisterResult._(error: 'Ce pseudo est deja utilise');

  factory RegisterResult.unauthorized() =>
      RegisterResult._(error: 'Action non autorisee');
}

final authServiceProvider = Provider<AuthService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AuthService(db);
});