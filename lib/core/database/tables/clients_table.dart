import 'package:drift/drift.dart';

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomComplet => text().withLength(min: 2, max: 200)();
  TextColumn get telephone => text().withDefault(const Constant(''))();
  TextColumn get adresse => text().withDefault(const Constant(''))();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  DateTimeColumn get dateCreation => dateTime().withDefault(currentDateAndTime)();
}