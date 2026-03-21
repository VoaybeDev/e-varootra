import 'package:drift/drift.dart';

import 'product_units_table.dart';
import 'users_table.dart';

class PriceHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get produitUniteId => integer().references(ProductUnits, #id)();
  RealColumn get ancienPrix => real()();
  RealColumn get nouveauPrix => real()();
  IntColumn get utilisateurId => integer().references(Users, #id)();
  DateTimeColumn get dateModification => dateTime().withDefault(currentDateAndTime)();
}