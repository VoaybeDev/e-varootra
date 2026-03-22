import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../models/user_model.dart';
import '../../app/utils/constants.dart';

class AuthService {
  final AppDatabase _db;
  AuthService(this._db);

  static String hashPassword(String password) => 'hash_$password';

  Future<AuthResult> login(String pseudo, String password) async {
    final hash = hashPassword(password);
    final user = await _db.userDao.authenticate(pseudo, hash);

    if (user == null) return AuthResult.invalidCredentials();
    if (user.banni) return AuthResult.banned(user);
    if (!user.approuve) return AuthResult.pendingApproval(user);
    return AuthResult.success(user);
  }

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
        banni: const Value(false),
      ),
    );
    final user = await _db.userDao.getUserById(id);
    return RegisterResult.success(user!);
  }

  Future<RegisterResult> createAdmin({
    required String nomComplet,
    required String pseudo,
    required String password,
    required UserModel createdBy,
  }) async {
    if (!createdBy.estSuperuser) return RegisterResult.unauthorized();
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
        banni: const Value(false),
      ),
    );
    final user = await _db.userDao.getUserById(id);
    return RegisterResult.success(user!);
  }

  Future<void> approveUser(int userId, UserModel by) async {
    if (!by.estAdmin) return;
    await _db.userDao.approveUser(userId);
  }

  Future<void> rejectUser(int userId, UserModel by) async {
    if (!by.estAdmin) return;
    await _db.userDao.rejectUser(userId);
  }

  Future<void> banUser(int userId, UserModel by) async {
    if (!by.estAdmin) return;
    await _db.userDao.banUser(userId);
  }

  Future<void> unbanUser(int userId, UserModel by) async {
    if (!by.estAdmin) return;
    await _db.userDao.unbanUser(userId);
  }

  Future<void> permanentlyDeleteUser(int userId, UserModel by) async {
    if (!by.estAdmin) return;
    await _db.userDao.permanentlyDeleteUser(userId);
  }

  Future<void> requestReactivation(int userId) async {
    await _db.userDao.requestReactivation(userId);
  }

  Future<List<UserModel>> getPendingUsers() async =>
      _db.userDao.getPendingUsers();

  Future<List<UserModel>> getApprovedActiveUsers() async =>
      _db.userDao.getApprovedActiveUsers();

  Future<List<UserModel>> getBannedUsers() async =>
      _db.userDao.getBannedUsers();

  Future<UserModel?> getUserById(int id) async =>
      _db.userDao.getUserById(id);

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefOnboardingDone) ?? false;
  }

  Future<void> markOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefOnboardingDone, true);
  }

  Future<void> logout() async {}
}

class AuthResult {
  final UserModel? user;
  final String? error;
  final bool isPending;
  final bool isBanned;
  final bool isSuccess;

  const AuthResult._({
    this.user,
    this.error,
    this.isPending = false,
    this.isBanned = false,
    this.isSuccess = false,
  });

  factory AuthResult.success(UserModel u) =>
      AuthResult._(user: u, isSuccess: true);
  factory AuthResult.invalidCredentials() =>
      AuthResult._(error: 'Identifiants incorrects');
  factory AuthResult.pendingApproval(UserModel u) => AuthResult._(
      user: u,
      isPending: true,
      error: 'Compte en attente d\'approbation');
  factory AuthResult.banned(UserModel u) => AuthResult._(
      user: u,
      isBanned: true,
      error: 'Votre compte a ete banni');
}

class RegisterResult {
  final UserModel? user;
  final String? error;
  final bool isSuccess;

  const RegisterResult._({this.user, this.error, this.isSuccess = false});

  factory RegisterResult.success(UserModel u) =>
      RegisterResult._(user: u, isSuccess: true);
  factory RegisterResult.pseudoTaken() =>
      RegisterResult._(error: 'Ce pseudo est deja utilise');
  factory RegisterResult.unauthorized() =>
      RegisterResult._(error: 'Action non autorisee');
}

final authServiceProvider = Provider<AuthService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AuthService(db);
});