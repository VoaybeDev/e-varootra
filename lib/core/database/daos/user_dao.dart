import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/users_table.dart';
import '../../models/user_model.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  // Recuperer tous les utilisateurs
  Future<List<UserModel>> getAllUsers() async {
    final rows = await select(users).get();
    return rows.map(_toModel).toList();
  }

  // Recuperer un utilisateur par id
  Future<UserModel?> getUserById(int id) async {
    final row = await (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  // Recuperer un utilisateur par pseudo
  Future<UserModel?> getUserByPseudo(String pseudo) async {
    final row = await (select(users)..where((u) => u.pseudo.equals(pseudo))).getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  // Verifier si un pseudo existe deja
  Future<bool> pseudoExists(String pseudo, {int? excludeId}) async {
    var query = select(users)..where((u) => u.pseudo.equals(pseudo));
    if (excludeId != null) {
      query = query..where((u) => u.id.equals(excludeId).not());
    }
    final result = await query.getSingleOrNull();
    return result != null;
  }

  // Authentification
  Future<UserModel?> authenticate(String pseudo, String passwordHash) async {
    final row = await (select(users)
      ..where((u) => u.pseudo.equals(pseudo))
      ..where((u) => u.motDePasseHash.equals(passwordHash)))
        .getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  // Creer un utilisateur
  Future<int> createUser(UsersCompanion companion) async {
    return into(users).insert(companion);
  }

  // Mettre a jour un utilisateur
  Future<bool> updateUser(UsersCompanion companion) async {
    return update(users).replace(companion);
  }

  // Convertir en modele
  UserModel _toModel(User row) {
    return UserModel(
      id: row.id,
      nomComplet: row.nomComplet,
      pseudo: row.pseudo,
      motDePasseHash: row.motDePasseHash,
      dateCreation: row.dateCreation,
    );
  }
}