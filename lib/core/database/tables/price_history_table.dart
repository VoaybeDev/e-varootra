import 'package:drift/drift.dart';

class PriceHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get produitUniteId => integer()();
  RealColumn get ancienPrix => real()();
  RealColumn get nouveauPrix => real()();
  TextColumn get pseudo => text().withDefault(const Constant('?'))();
  TextColumn get role => text().withDefault(const Constant('utilisateur'))();
  DateTimeColumn get dateModification =>
      dateTime().withDefault(currentDateAndTime)();
}