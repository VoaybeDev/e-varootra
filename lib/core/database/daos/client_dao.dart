import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/clients_table.dart';
import '../../models/client_model.dart';

part 'client_dao.g.dart';

@DriftAccessor(tables: [Clients])
class ClientDao extends DatabaseAccessor<AppDatabase> with _$ClientDaoMixin {
  ClientDao(super.db);

  // Tous les clients actifs
  Future<List<ClientModel>> getActiveClients() async {
    final rows = await (select(clients)
      ..where((c) => c.actif.equals(true))
      ..orderBy([(c) => OrderingTerm.asc(c.nomComplet)]))
        .get();
    return rows.map(_toModel).toList();
  }

  // Tous les clients (y compris inactifs)
  Future<List<ClientModel>> getAllClients() async {
    final rows = await (select(clients)
      ..orderBy([(c) => OrderingTerm.asc(c.nomComplet)]))
        .get();
    return rows.map(_toModel).toList();
  }

  // Recherche clients actifs
  Future<List<ClientModel>> searchClients(String query) async {
    final q = '%${query.toLowerCase()}%';
    final rows = await (select(clients)
      ..where((c) => c.actif.equals(true))
      ..where((c) => c.nomComplet.lower().like(q) | c.telephone.like(q))
      ..orderBy([(c) => OrderingTerm.asc(c.nomComplet)]))
        .get();
    return rows.map(_toModel).toList();
  }

  // Recuperer client par id
  Future<ClientModel?> getClientById(int id) async {
    final row = await (select(clients)..where((c) => c.id.equals(id))).getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  // Creer client
  Future<int> createClient(ClientsCompanion companion) async {
    return into(clients).insert(companion);
  }

  // Mettre a jour client
  Future<bool> updateClient(ClientsCompanion companion) async {
    return update(clients).replace(companion);
  }

  // Suppression douce (desactiver)
  Future<void> deactivateClient(int id) async {
    await (update(clients)..where((c) => c.id.equals(id))).write(
      const ClientsCompanion(actif: Value(false)),
    );
  }

  // Convertir en modele
  ClientModel _toModel(Client row) {
    return ClientModel(
      id: row.id,
      nomComplet: row.nomComplet,
      telephone: row.telephone,
      adresse: row.adresse,
      actif: row.actif,
      dateCreation: row.dateCreation,
    );
  }
}