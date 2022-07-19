
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
part 'drift_database.g.dart';

class HistoryGames extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get correct => integer()();
  IntColumn get wrong => integer()();
  IntColumn get hints => integer()();
  TextColumn get time => text()();
  TextColumn get date => text()();
  TextColumn get stopWatch => text()();
  TextColumn get wrongAnswersList => text()();

  @override
  Set<Column> get primaryKey => {id};
}

LazyDatabase _openConection(){
  return LazyDatabase(()async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [HistoryGames])
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_openConection());

  @override 
  int get schemaVersion => 1;


  Future<List<HistoryGame>> getAllHistoryGames() => select(historyGames).get();
  Stream<List<HistoryGame>> watchAllHistoryGames() => select(historyGames).watch();
  Future insertHistoryGame(HistoryGamesCompanion historyGame) => into(historyGames).insert(historyGame);
  Future updateHistoryGame(HistoryGamesCompanion historyGame) => update(historyGames).replace(historyGame);
  Future deleteHistoryGame(HistoryGamesCompanion historyGame) => delete(historyGames).delete(historyGame);

}