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

  // En attente d'approbation (pas banni, pas approuve)
  Future<List<UserModel>> getPendingUsers() async {
    final rows = await (select(users)
      ..where((u) => u.approuve.equals(false))
      ..where((u) => u.banni.equals(false))
      ..where((u) => u.role.equals('utilisateur')))
        .get();
    return rows.map(_toModel).toList();
  }

  // Utilisateurs actifs (approuves et non bannis)
  Future<List<UserModel>> getApprovedActiveUsers() async {
    final rows = await (select(users)
      ..where((u) => u.approuve.equals(true))
      ..where((u) => u.banni.equals(false))
      ..orderBy([(u) => OrderingTerm.asc(u.nomComplet)]))
        .get();
    return rows.map(_toModel).toList();
  }

  // Utilisateurs bannis
  Future<List<UserModel>> getBannedUsers() async {
    final rows = await (select(users)
      ..where((u) => u.banni.equals(true))
      ..orderBy([(u) => OrderingTerm.desc(u.dateBan)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<UserModel?> getUserById(int id) async {
    final row = await (select(users)..where((u) => u.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<UserModel?> getUserByPseudo(String pseudo) async {
    final row =
    await (select(users)..where((u) => u.pseudo.equals(pseudo)))
        .getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<bool> pseudoExists(String pseudo, {int? excludeId}) async {
    var q = select(users)..where((u) => u.pseudo.equals(pseudo));
    if (excludeId != null) {
      q = q..where((u) => u.id.equals(excludeId).not());
    }
    return await q.getSingleOrNull() != null;
  }

  Future<UserModel?> authenticate(String pseudo, String passwordHash) async {
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
      const UsersCompanion(approuve: Value(true), banni: Value(false)),
    );
  }

  Future<void> rejectUser(int id) async {
    await (delete(users)..where((u) => u.id.equals(id))).go();
  }

  // Bannir un utilisateur
  Future<void> banUser(int id) async {
    await (update(users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(
        banni: const Value(true),
        approuve: const Value(false),
        dateBan: Value(DateTime.now()),
      ),
    );
  }

  // Debannir - restaure l'acces actif
  Future<void> unbanUser(int id) async {
    await (update(users)..where((u) => u.id.equals(id))).write(
      const UsersCompanion(
        banni: Value(false),
        approuve: Value(true),
        dateBan: Value(null),
      ),
    );
  }

  // Supprimer definitivement
  Future<void> permanentlyDeleteUser(int id) async {
    await (delete(users)..where((u) => u.id.equals(id))).go();
  }

  // Demander reactivation (banni -> en attente)
  Future<void> requestReactivation(int id) async {
    await (update(users)..where((u) => u.id.equals(id))).write(
      const UsersCompanion(
        banni: Value(false),
        approuve: Value(false),
        dateBan: Value(null),
      ),
    );
  }

  Future<void> updateUserRole(int id, String role) async {
    await (update(users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(role: Value(role)),
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
      banni: row.banni,
      dateBan: row.dateBan,
      dateCreation: row.dateCreation,
    );
  }
}