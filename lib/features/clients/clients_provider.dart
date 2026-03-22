import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/models/client_model.dart';

final clientsListProvider = FutureProvider<List<ClientModel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.clientDao.getActiveClients();
});

final clientsSearchProvider = StateProvider<String>((ref) => '');

final clientsFilteredProvider =
FutureProvider<List<ClientModel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final search = ref.watch(clientsSearchProvider);
  if (search.trim().isEmpty) {
    return db.clientDao.getActiveClients();
  }
  return db.clientDao.searchClients(search);
});

class ClientsNotifier
    extends StateNotifier<AsyncValue<List<ClientModel>>> {
  final AppDatabase _db;

  ClientsNotifier(this._db) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final list = await _db.clientDao.getActiveClients();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> search(String query) async {
    try {
      state = const AsyncValue.loading();
      final list = query.trim().isEmpty
          ? await _db.clientDao.getActiveClients()
          : await _db.clientDao.searchClients(query);
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<String?> create({
    required String nomComplet,
    required String telephone,
    required String adresse,
    String? cin,
    String? photoCin,
    String? photo,
  }) async {
    try {
      await _db.clientDao.createClient(
        ClientsCompanion(
          nomComplet: Value(nomComplet),
          telephone: Value(telephone),
          adresse: Value(adresse),
          cin: Value(cin),
          photoCin: Value(photoCin),
          photo: Value(photo),
        ),
      );
      await load();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> update({
    required int id,
    required String nomComplet,
    required String telephone,
    required String adresse,
    String? cin,
    String? photoCin,
    String? photo,
  }) async {
    try {
      // Appel direct avec parametres explicites
      await _db.clientDao.updateClient(
        id: id,
        nomComplet: nomComplet,
        telephone: telephone,
        adresse: adresse,
        cin: cin,
        photoCin: photoCin,
        photo: photo,
      );
      await load();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

// Pas de suppression - les clients sont permanents
}

final clientsNotifierProvider = StateNotifierProvider<ClientsNotifier,
    AsyncValue<List<ClientModel>>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ClientsNotifier(db);
});