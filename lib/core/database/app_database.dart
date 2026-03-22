import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables/users_table.dart';
import 'tables/clients_table.dart';
import 'tables/products_table.dart';
import 'tables/units_table.dart';
import 'tables/product_units_table.dart';
import 'tables/price_history_table.dart';
import 'tables/debts_table.dart';
import 'tables/payments_table.dart';
import 'daos/user_dao.dart';
import 'daos/client_dao.dart';
import 'daos/product_dao.dart';
import 'daos/debt_dao.dart';
import 'daos/payment_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users, Clients, Products, Units,
    ProductUnits, PriceHistory, Debts, Payments,
  ],
  daos: [UserDao, ClientDao, ProductDao, DebtDao, PaymentDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedInitialData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(clients, clients.cin);
          await m.addColumn(clients, clients.photoCin);
          await m.addColumn(clients, clients.photo);
        }
        if (from < 3) {
          await m.addColumn(users, users.role);
          await m.addColumn(users, users.approuve);
          await customStatement(
              "UPDATE users SET role='superuser', approuve=1 WHERE id=1");
          await customStatement(
              "UPDATE users SET role='utilisateur', approuve=1 WHERE id!=1");
        }
        if (from < 4) {
          await m.addColumn(priceHistory, priceHistory.pseudo);
        }
        if (from < 5) {
          await m.addColumn(users, users.banni);
          await m.addColumn(users, users.dateBan);
          await m.addColumn(priceHistory, priceHistory.role);
        }
      },
    );
  }

  Future<void> _seedInitialData() async {
    await into(users).insert(UsersCompanion.insert(
      nomComplet: 'VoaybeDev',
      pseudo: 'voaybe',
      motDePasseHash: _hashPassword('voaybe2026'),
      role: const Value('superuser'),
      approuve: const Value(true),
      banni: const Value(false),
    ));

    final unitesDefaut = [
      UnitsCompanion.insert(nom: 'Kilogramme', symbole: const Value('kg')),
      UnitsCompanion.insert(nom: 'Gramme', symbole: const Value('g')),
      UnitsCompanion.insert(nom: 'Litre', symbole: const Value('L')),
      UnitsCompanion.insert(nom: 'Millilitre', symbole: const Value('mL')),
      UnitsCompanion.insert(nom: 'Piece', symbole: const Value('pce')),
      UnitsCompanion.insert(nom: 'Sac', symbole: const Value('sac')),
      UnitsCompanion.insert(nom: 'Boite', symbole: const Value('boite')),
      UnitsCompanion.insert(nom: 'Carton', symbole: const Value('carton')),
      UnitsCompanion.insert(nom: 'Bouteille', symbole: const Value('btl')),
      UnitsCompanion.insert(nom: 'Paquet', symbole: const Value('pqt')),
    ];
    for (final u in unitesDefaut) {
      await into(units).insert(u);
    }
  }

  static String _hashPassword(String password) => 'hash_$password';

  static QueryExecutor _openConnection() =>
      driftDatabase(name: 'e_varootra_db');
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Override in main()');
});