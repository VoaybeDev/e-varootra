import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/users_table.dart';
import '../../models/user_model.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<List<UserModel>> getAllUsers() async {
    final rows = await select(users).get();
    return rows.map(_toModel).toList();
  }

  Future<List<UserModel>> getPendingUsers() async {
    final rows = await (select(users)
      ..where((u) => u.approuve.equals(false))
      ..where((u) => u.role.equals('utilisateur')))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<List<UserModel>> getApprovedUsers() async {
    final rows = await (select(users)
      ..where((u) => u.approuve.equals(true))
      ..orderBy([(u) => OrderingTerm.asc(u.nomComplet)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<UserModel?> getUserById(int id) async {
    final row = await (select(users)
      ..where((u) => u.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<UserModel?> getUserByPseudo(String pseudo) async {
    final row = await (select(users)
      ..where((u) => u.pseudo.equals(pseudo)))
        .getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<bool> pseudoExists(String pseudo, {int? excludeId}) async {
    var query = select(users)..where((u) => u.pseudo.equals(pseudo));
    if (excludeId != null) {
      query = query..where((u) => u.id.equals(excludeId).not());
    }
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<UserModel?> authenticate(
      String pseudo, String passwordHash) async {
    final row = await (select(users)
      ..where((u) => u.pseudo.equals(pseudo))
      ..where((u) => u.motDePasseHash.equals(passwordHash)))
        .getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<int> createUser(UsersCompanion companion) async {
    return into(users).insert(companion);
  }

  Future<void> approveUser(int id) async {
    await (update(users)..where((u) => u.id.equals(id))).write(
      const UsersCompanion(approuve: Value(true)),
    );
  }

  Future<void> rejectUser(int id) async {
    await (delete(users)..where((u) => u.id.equals(id))).go();
  }

  Future<void> updateUserRole(int id, String role) async {
    await (update(users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(role: Value(role)),
    );
  }

  Future<void> updatePassword(int id, String newHash) async {
    await (update(users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(motDePasseHash: Value(newHash)),
    );
  }

  UserModel _toModel(User row) {
    return UserModel(
      id: row.id,
      nomComplet: row.nomComplet,
      pseudo: row.pseudo,
      motDePasseHash: row.motDePasseHash,
      role: UserModel.roleFromString(row.role),
      approuve: row.approuve,
      dateCreation: row.dateCreation,
    );
  }
}