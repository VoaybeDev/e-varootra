import 'package:drift/drift.dart';

class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nom => text().withLength(min: 1, max: 100)();
  TextColumn get symbole => text().withDefault(const Constant(''))();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
}