import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../database/tables/users_table.dart';
import '../models/user_model.dart';
import '../../app/utils/constants.dart';

class AuthService {
  final AppDatabase _db;

  AuthService(this._db);

  // Hash du mot de passe
  static String hashPassword(String password) {
    return 'hash_$password';
  }

  // Connexion
  Future<UserModel?> login(String pseudo, String password) async {
    final hash = hashPassword(password);
    return _db.userDao.authenticate(pseudo, hash);
  }

  // Inscription
  Future<UserModel?> register({
    required String nomComplet,
    required String pseudo,
    required String password,
  }) async {
    final exists = await _db.userDao.pseudoExists(pseudo);
    if (exists) return null;

    final hash = hashPassword(password);
    final id = await _db.userDao.createUser(
      UsersCompanion.insert(
        nomComplet: nomComplet,
        pseudo: pseudo,
        motDePasseHash: hash,
      ),
    );
    return _db.userDao.getUserById(id);
  }

  // Recuperer utilisateur par id
  Future<UserModel?> getUserById(int id) async {
    return _db.userDao.getUserById(id);
  }

  // Sauvegarder session
  Future<void> saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefCurrentUserId, userId);
    await prefs.setBool(AppConstants.prefOnboardingDone, true);
  }

  // Recuperer session
  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(AppConstants.prefCurrentUserId);
    return id;
  }

  // Verifier si onboarding fait
  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefOnboardingDone) ?? false;
  }

  // Marquer onboarding fait
  Future<void> markOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefOnboardingDone, true);
  }

  // Deconnexion
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefCurrentUserId);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AuthService(db);
});