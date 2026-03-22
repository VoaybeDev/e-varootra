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

  // Utilise write() avec where() pour mettre a jour seulement les champs fournis
  Future<void> updateClient({
    required int id,
    required String nomComplet,
    required String telephone,
    required String adresse,
    String? cin,
    String? photoCin,
    String? photo,
  }) async {
    await (update(clients)..where((c) => c.id.equals(id))).write(
      ClientsCompanion(
        nomComplet: Value(nomComplet),
        telephone: Value(telephone),
        adresse: Value(adresse),
        cin: Value(cin),
        photoCin: Value(photoCin),
        photo: Value(photo),
      ),
    );
  }

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