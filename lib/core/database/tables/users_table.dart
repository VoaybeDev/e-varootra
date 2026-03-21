import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomComplet => text().withLength(min: 2, max: 200)();
  TextColumn get pseudo => text().withLength(min: 3, max: 50).unique()();
  TextColumn get motDePasseHash => text()();
  DateTimeColumn get dateCreation => dateTime().withDefault(currentDateAndTime)();
}