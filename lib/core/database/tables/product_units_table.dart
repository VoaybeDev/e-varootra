import 'package:drift/drift.dart';

import 'products_table.dart';
import 'units_table.dart';

class ProductUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get produitId => integer().references(Products, #id)();
  IntColumn get uniteId => integer().references(Units, #id)();
  RealColumn get prixUnitaire => real().withDefault(const Constant(0.0))();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  DateTimeColumn get dateModification => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {produitId, uniteId},
  ];
}