import 'package:drift/drift.dart';

import 'clients_table.dart';
import 'product_units_table.dart';
import 'users_table.dart';

class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get numeroFacture => text().withLength(min: 1, max: 50)();
  IntColumn get clientId => integer().references(Clients, #id)();
  IntColumn get produitUniteId => integer().references(ProductUnits, #id)();
  RealColumn get quantite => real()();
  RealColumn get prixUnitaireFige => real()();
  RealColumn get montantTotal => real()();
  RealColumn get montantPaye => real().withDefault(const Constant(0.0))();
  RealColumn get montantRestant => real()();
  TextColumn get statut => text().withDefault(const Constant('active'))();
  IntColumn get enregistrePar => integer().references(Users, #id)();
  DateTimeColumn get dateDette => dateTime()();
  DateTimeColumn get dateModification => dateTime().withDefault(currentDateAndTime)();
}