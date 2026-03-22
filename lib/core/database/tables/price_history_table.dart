import 'package:drift/drift.dart';

class PriceHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get produitUniteId => integer()();
  RealColumn get ancienPrix => real()();
  RealColumn get nouveauPrix => real()();
  // Pseudo de l'utilisateur qui a fait le changement
  TextColumn get pseudo => text().withDefault(const Constant('?'))();
  DateTimeColumn get dateModification =>
      dateTime().withDefault(currentDateAndTime)();
}