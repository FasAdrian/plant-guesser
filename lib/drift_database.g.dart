// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class HistoryGame extends DataClass implements Insertable<HistoryGame> {
  final int id;
  final int correct;
  final int wrong;
  final int hints;
  final String time;
  final String date;
  final String stopWatch;
  final String wrongAnswersList;
  HistoryGame(
      {required this.id,
      required this.correct,
      required this.wrong,
      required this.hints,
      required this.time,
      required this.date,
      required this.stopWatch,
      required this.wrongAnswersList});
  factory HistoryGame.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return HistoryGame(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      correct: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}correct'])!,
      wrong: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}wrong'])!,
      hints: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hints'])!,
      time: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time'])!,
      date: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      stopWatch: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}stop_watch'])!,
      wrongAnswersList: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}wrong_answers_list'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['correct'] = Variable<int>(correct);
    map['wrong'] = Variable<int>(wrong);
    map['hints'] = Variable<int>(hints);
    map['time'] = Variable<String>(time);
    map['date'] = Variable<String>(date);
    map['stop_watch'] = Variable<String>(stopWatch);
    map['wrong_answers_list'] = Variable<String>(wrongAnswersList);
    return map;
  }

  HistoryGamesCompanion toCompanion(bool nullToAbsent) {
    return HistoryGamesCompanion(
      id: Value(id),
      correct: Value(correct),
      wrong: Value(wrong),
      hints: Value(hints),
      time: Value(time),
      date: Value(date),
      stopWatch: Value(stopWatch),
      wrongAnswersList: Value(wrongAnswersList),
    );
  }

  factory HistoryGame.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryGame(
      id: serializer.fromJson<int>(json['id']),
      correct: serializer.fromJson<int>(json['correct']),
      wrong: serializer.fromJson<int>(json['wrong']),
      hints: serializer.fromJson<int>(json['hints']),
      time: serializer.fromJson<String>(json['time']),
      date: serializer.fromJson<String>(json['date']),
      stopWatch: serializer.fromJson<String>(json['stopWatch']),
      wrongAnswersList: serializer.fromJson<String>(json['wrongAnswersList']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'correct': serializer.toJson<int>(correct),
      'wrong': serializer.toJson<int>(wrong),
      'hints': serializer.toJson<int>(hints),
      'time': serializer.toJson<String>(time),
      'date': serializer.toJson<String>(date),
      'stopWatch': serializer.toJson<String>(stopWatch),
      'wrongAnswersList': serializer.toJson<String>(wrongAnswersList),
    };
  }

  HistoryGame copyWith(
          {int? id,
          int? correct,
          int? wrong,
          int? hints,
          String? time,
          String? date,
          String? stopWatch,
          String? wrongAnswersList}) =>
      HistoryGame(
        id: id ?? this.id,
        correct: correct ?? this.correct,
        wrong: wrong ?? this.wrong,
        hints: hints ?? this.hints,
        time: time ?? this.time,
        date: date ?? this.date,
        stopWatch: stopWatch ?? this.stopWatch,
        wrongAnswersList: wrongAnswersList ?? this.wrongAnswersList,
      );
  @override
  String toString() {
    return (StringBuffer('HistoryGame(')
          ..write('id: $id, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('hints: $hints, ')
          ..write('time: $time, ')
          ..write('date: $date, ')
          ..write('stopWatch: $stopWatch, ')
          ..write('wrongAnswersList: $wrongAnswersList')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, correct, wrong, hints, time, date, stopWatch, wrongAnswersList);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryGame &&
          other.id == this.id &&
          other.correct == this.correct &&
          other.wrong == this.wrong &&
          other.hints == this.hints &&
          other.time == this.time &&
          other.date == this.date &&
          other.stopWatch == this.stopWatch &&
          other.wrongAnswersList == this.wrongAnswersList);
}

class HistoryGamesCompanion extends UpdateCompanion<HistoryGame> {
  final Value<int> id;
  final Value<int> correct;
  final Value<int> wrong;
  final Value<int> hints;
  final Value<String> time;
  final Value<String> date;
  final Value<String> stopWatch;
  final Value<String> wrongAnswersList;
  const HistoryGamesCompanion({
    this.id = const Value.absent(),
    this.correct = const Value.absent(),
    this.wrong = const Value.absent(),
    this.hints = const Value.absent(),
    this.time = const Value.absent(),
    this.date = const Value.absent(),
    this.stopWatch = const Value.absent(),
    this.wrongAnswersList = const Value.absent(),
  });
  HistoryGamesCompanion.insert({
    this.id = const Value.absent(),
    required int correct,
    required int wrong,
    required int hints,
    required String time,
    required String date,
    required String stopWatch,
    required String wrongAnswersList,
  })  : correct = Value(correct),
        wrong = Value(wrong),
        hints = Value(hints),
        time = Value(time),
        date = Value(date),
        stopWatch = Value(stopWatch),
        wrongAnswersList = Value(wrongAnswersList);
  static Insertable<HistoryGame> custom({
    Expression<int>? id,
    Expression<int>? correct,
    Expression<int>? wrong,
    Expression<int>? hints,
    Expression<String>? time,
    Expression<String>? date,
    Expression<String>? stopWatch,
    Expression<String>? wrongAnswersList,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (correct != null) 'correct': correct,
      if (wrong != null) 'wrong': wrong,
      if (hints != null) 'hints': hints,
      if (time != null) 'time': time,
      if (date != null) 'date': date,
      if (stopWatch != null) 'stop_watch': stopWatch,
      if (wrongAnswersList != null) 'wrong_answers_list': wrongAnswersList,
    });
  }

  HistoryGamesCompanion copyWith(
      {Value<int>? id,
      Value<int>? correct,
      Value<int>? wrong,
      Value<int>? hints,
      Value<String>? time,
      Value<String>? date,
      Value<String>? stopWatch,
      Value<String>? wrongAnswersList}) {
    return HistoryGamesCompanion(
      id: id ?? this.id,
      correct: correct ?? this.correct,
      wrong: wrong ?? this.wrong,
      hints: hints ?? this.hints,
      time: time ?? this.time,
      date: date ?? this.date,
      stopWatch: stopWatch ?? this.stopWatch,
      wrongAnswersList: wrongAnswersList ?? this.wrongAnswersList,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (wrong.present) {
      map['wrong'] = Variable<int>(wrong.value);
    }
    if (hints.present) {
      map['hints'] = Variable<int>(hints.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (stopWatch.present) {
      map['stop_watch'] = Variable<String>(stopWatch.value);
    }
    if (wrongAnswersList.present) {
      map['wrong_answers_list'] = Variable<String>(wrongAnswersList.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryGamesCompanion(')
          ..write('id: $id, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('hints: $hints, ')
          ..write('time: $time, ')
          ..write('date: $date, ')
          ..write('stopWatch: $stopWatch, ')
          ..write('wrongAnswersList: $wrongAnswersList')
          ..write(')'))
        .toString();
  }
}

class $HistoryGamesTable extends HistoryGames
    with TableInfo<$HistoryGamesTable, HistoryGame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryGamesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _correctMeta = const VerificationMeta('correct');
  @override
  late final GeneratedColumn<int?> correct = GeneratedColumn<int?>(
      'correct', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _wrongMeta = const VerificationMeta('wrong');
  @override
  late final GeneratedColumn<int?> wrong = GeneratedColumn<int?>(
      'wrong', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _hintsMeta = const VerificationMeta('hints');
  @override
  late final GeneratedColumn<int?> hints = GeneratedColumn<int?>(
      'hints', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String?> time = GeneratedColumn<String?>(
      'time', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String?> date = GeneratedColumn<String?>(
      'date', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _stopWatchMeta = const VerificationMeta('stopWatch');
  @override
  late final GeneratedColumn<String?> stopWatch = GeneratedColumn<String?>(
      'stop_watch', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _wrongAnswersListMeta =
      const VerificationMeta('wrongAnswersList');
  @override
  late final GeneratedColumn<String?> wrongAnswersList =
      GeneratedColumn<String?>('wrong_answers_list', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, correct, wrong, hints, time, date, stopWatch, wrongAnswersList];
  @override
  String get aliasedName => _alias ?? 'history_games';
  @override
  String get actualTableName => 'history_games';
  @override
  VerificationContext validateIntegrity(Insertable<HistoryGame> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('wrong')) {
      context.handle(
          _wrongMeta, wrong.isAcceptableOrUnknown(data['wrong']!, _wrongMeta));
    } else if (isInserting) {
      context.missing(_wrongMeta);
    }
    if (data.containsKey('hints')) {
      context.handle(
          _hintsMeta, hints.isAcceptableOrUnknown(data['hints']!, _hintsMeta));
    } else if (isInserting) {
      context.missing(_hintsMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('stop_watch')) {
      context.handle(_stopWatchMeta,
          stopWatch.isAcceptableOrUnknown(data['stop_watch']!, _stopWatchMeta));
    } else if (isInserting) {
      context.missing(_stopWatchMeta);
    }
    if (data.containsKey('wrong_answers_list')) {
      context.handle(
          _wrongAnswersListMeta,
          wrongAnswersList.isAcceptableOrUnknown(
              data['wrong_answers_list']!, _wrongAnswersListMeta));
    } else if (isInserting) {
      context.missing(_wrongAnswersListMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryGame map(Map<String, dynamic> data, {String? tablePrefix}) {
    return HistoryGame.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $HistoryGamesTable createAlias(String alias) {
    return $HistoryGamesTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $HistoryGamesTable historyGames = $HistoryGamesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [historyGames];
}
