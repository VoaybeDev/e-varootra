import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nom => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  DateTimeColumn get dateCreation => dateTime().withDefault(currentDateAndTime)();
}