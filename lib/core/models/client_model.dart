import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/clients_table.dart';
import '../../models/client_model.dart';

part 'client_dao.g.dart';

@DriftAccessor(tables: [Clients])
class ClientDao extends DatabaseAccessor<AppDatabase>
    with _$ClientDaoMixin {
  ClientDao(super.db);

  Future<List<ClientModel>> getActiveClients() async {
    final rows = await (select(clients)
      ..where((c) => c.actif.equals(true))
      ..orderBy([(c) => OrderingTerm.asc(c.nomComplet)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<List<ClientModel>> getAllClients() async {
    final rows = await (select(clients)
      ..orderBy([(c) => OrderingTerm.asc(c.nomComplet)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<List<ClientModel>> searchClients(String query) async {
    final q = '%${query.toLowerCase()}%';
    final rows = await (select(clients)
      ..where((c) => c.actif.equals(true))
      ..where(
              (c) => c.nomComplet.lower().like(q) | c.telephone.like(q))
      ..orderBy([(c) => OrderingTerm.asc(c.nomComplet)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<ClientModel?> getClientById(int id) async {
    final row = await (select(clients)
      ..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<int> createClient(ClientsCompanion companion) async {
    return into(clients).insert(companion);
  }

  Future<bool> updateClient(ClientsCompanion companion) async {
    return update(clients).replace(companion);
  }

  // Pas de suppression - les clients ne peuvent jamais etre supprimes

  ClientModel _toModel(Client row) {
    return ClientModel(
      id: row.id,
      nomComplet: row.nomComplet,
      telephone: row.telephone,
      adresse: row.adresse,
      cin: row.cin,
      photoCin: row.photoCin,
      photo: row.photo,
      actif: row.actif,
      dateCreation: row.dateCreation,
    );
  }
}