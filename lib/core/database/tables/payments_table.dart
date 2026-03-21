import 'package:drift/drift.dart';

import 'debts_table.dart';
import 'users_table.dart';

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get detteId => integer().references(Debts, #id)();
  RealColumn get montantPaye => real()();
  TextColumn get modePaiement => text().withDefault(const Constant('Especes'))();
  TextColumn get referencePaiement => text().withDefault(const Constant(''))();
  IntColumn get enregistrePar => integer().references(Users, #id)();
  DateTimeColumn get datePaiement => dateTime()();
  DateTimeColumn get dateCreation => dateTime().withDefault(currentDateAndTime)();
}