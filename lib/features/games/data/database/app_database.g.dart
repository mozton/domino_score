// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GamesTable extends Games with TableInfo<$GamesTable, GameRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actualRoundMeta = const VerificationMeta(
    'actualRound',
  );
  @override
  late final GeneratedColumn<int> actualRound = GeneratedColumn<int>(
    'actual_round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsToWinMeta = const VerificationMeta(
    'pointsToWin',
  );
  @override
  late final GeneratedColumn<int> pointsToWin = GeneratedColumn<int>(
    'points_to_win',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _winnerTeamNameMeta = const VerificationMeta(
    'winnerTeamName',
  );
  @override
  late final GeneratedColumn<String> winnerTeamName = GeneratedColumn<String>(
    'winner_team_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _myTeamIndexMeta = const VerificationMeta(
    'myTeamIndex',
  );
  @override
  late final GeneratedColumn<int> myTeamIndex = GeneratedColumn<int>(
    'my_team_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actualRound,
    pointsToWin,
    createdAt,
    winnerTeamName,
    myTeamIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('actual_round')) {
      context.handle(
        _actualRoundMeta,
        actualRound.isAcceptableOrUnknown(
          data['actual_round']!,
          _actualRoundMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualRoundMeta);
    }
    if (data.containsKey('points_to_win')) {
      context.handle(
        _pointsToWinMeta,
        pointsToWin.isAcceptableOrUnknown(
          data['points_to_win']!,
          _pointsToWinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pointsToWinMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('winner_team_name')) {
      context.handle(
        _winnerTeamNameMeta,
        winnerTeamName.isAcceptableOrUnknown(
          data['winner_team_name']!,
          _winnerTeamNameMeta,
        ),
      );
    }
    if (data.containsKey('my_team_index')) {
      context.handle(
        _myTeamIndexMeta,
        myTeamIndex.isAcceptableOrUnknown(
          data['my_team_index']!,
          _myTeamIndexMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      actualRound: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_round'],
      )!,
      pointsToWin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_to_win'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      winnerTeamName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}winner_team_name'],
      ),
      myTeamIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}my_team_index'],
      ),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class GameRow extends DataClass implements Insertable<GameRow> {
  final int id;
  final int actualRound;
  final int pointsToWin;
  final DateTime createdAt;
  final String? winnerTeamName;

  /// Equipo en el que juega el usuario (metodología de juego).
  final int? myTeamIndex;
  const GameRow({
    required this.id,
    required this.actualRound,
    required this.pointsToWin,
    required this.createdAt,
    this.winnerTeamName,
    this.myTeamIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['actual_round'] = Variable<int>(actualRound);
    map['points_to_win'] = Variable<int>(pointsToWin);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || winnerTeamName != null) {
      map['winner_team_name'] = Variable<String>(winnerTeamName);
    }
    if (!nullToAbsent || myTeamIndex != null) {
      map['my_team_index'] = Variable<int>(myTeamIndex);
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      actualRound: Value(actualRound),
      pointsToWin: Value(pointsToWin),
      createdAt: Value(createdAt),
      winnerTeamName: winnerTeamName == null && nullToAbsent
          ? const Value.absent()
          : Value(winnerTeamName),
      myTeamIndex: myTeamIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(myTeamIndex),
    );
  }

  factory GameRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameRow(
      id: serializer.fromJson<int>(json['id']),
      actualRound: serializer.fromJson<int>(json['actualRound']),
      pointsToWin: serializer.fromJson<int>(json['pointsToWin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      winnerTeamName: serializer.fromJson<String?>(json['winnerTeamName']),
      myTeamIndex: serializer.fromJson<int?>(json['myTeamIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actualRound': serializer.toJson<int>(actualRound),
      'pointsToWin': serializer.toJson<int>(pointsToWin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'winnerTeamName': serializer.toJson<String?>(winnerTeamName),
      'myTeamIndex': serializer.toJson<int?>(myTeamIndex),
    };
  }

  GameRow copyWith({
    int? id,
    int? actualRound,
    int? pointsToWin,
    DateTime? createdAt,
    Value<String?> winnerTeamName = const Value.absent(),
    Value<int?> myTeamIndex = const Value.absent(),
  }) => GameRow(
    id: id ?? this.id,
    actualRound: actualRound ?? this.actualRound,
    pointsToWin: pointsToWin ?? this.pointsToWin,
    createdAt: createdAt ?? this.createdAt,
    winnerTeamName: winnerTeamName.present
        ? winnerTeamName.value
        : this.winnerTeamName,
    myTeamIndex: myTeamIndex.present ? myTeamIndex.value : this.myTeamIndex,
  );
  GameRow copyWithCompanion(GamesCompanion data) {
    return GameRow(
      id: data.id.present ? data.id.value : this.id,
      actualRound: data.actualRound.present
          ? data.actualRound.value
          : this.actualRound,
      pointsToWin: data.pointsToWin.present
          ? data.pointsToWin.value
          : this.pointsToWin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      winnerTeamName: data.winnerTeamName.present
          ? data.winnerTeamName.value
          : this.winnerTeamName,
      myTeamIndex: data.myTeamIndex.present
          ? data.myTeamIndex.value
          : this.myTeamIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameRow(')
          ..write('id: $id, ')
          ..write('actualRound: $actualRound, ')
          ..write('pointsToWin: $pointsToWin, ')
          ..write('createdAt: $createdAt, ')
          ..write('winnerTeamName: $winnerTeamName, ')
          ..write('myTeamIndex: $myTeamIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    actualRound,
    pointsToWin,
    createdAt,
    winnerTeamName,
    myTeamIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameRow &&
          other.id == this.id &&
          other.actualRound == this.actualRound &&
          other.pointsToWin == this.pointsToWin &&
          other.createdAt == this.createdAt &&
          other.winnerTeamName == this.winnerTeamName &&
          other.myTeamIndex == this.myTeamIndex);
}

class GamesCompanion extends UpdateCompanion<GameRow> {
  final Value<int> id;
  final Value<int> actualRound;
  final Value<int> pointsToWin;
  final Value<DateTime> createdAt;
  final Value<String?> winnerTeamName;
  final Value<int?> myTeamIndex;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.actualRound = const Value.absent(),
    this.pointsToWin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.winnerTeamName = const Value.absent(),
    this.myTeamIndex = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required int actualRound,
    required int pointsToWin,
    required DateTime createdAt,
    this.winnerTeamName = const Value.absent(),
    this.myTeamIndex = const Value.absent(),
  }) : actualRound = Value(actualRound),
       pointsToWin = Value(pointsToWin),
       createdAt = Value(createdAt);
  static Insertable<GameRow> custom({
    Expression<int>? id,
    Expression<int>? actualRound,
    Expression<int>? pointsToWin,
    Expression<DateTime>? createdAt,
    Expression<String>? winnerTeamName,
    Expression<int>? myTeamIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actualRound != null) 'actual_round': actualRound,
      if (pointsToWin != null) 'points_to_win': pointsToWin,
      if (createdAt != null) 'created_at': createdAt,
      if (winnerTeamName != null) 'winner_team_name': winnerTeamName,
      if (myTeamIndex != null) 'my_team_index': myTeamIndex,
    });
  }

  GamesCompanion copyWith({
    Value<int>? id,
    Value<int>? actualRound,
    Value<int>? pointsToWin,
    Value<DateTime>? createdAt,
    Value<String?>? winnerTeamName,
    Value<int?>? myTeamIndex,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      actualRound: actualRound ?? this.actualRound,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      createdAt: createdAt ?? this.createdAt,
      winnerTeamName: winnerTeamName ?? this.winnerTeamName,
      myTeamIndex: myTeamIndex ?? this.myTeamIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actualRound.present) {
      map['actual_round'] = Variable<int>(actualRound.value);
    }
    if (pointsToWin.present) {
      map['points_to_win'] = Variable<int>(pointsToWin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (winnerTeamName.present) {
      map['winner_team_name'] = Variable<String>(winnerTeamName.value);
    }
    if (myTeamIndex.present) {
      map['my_team_index'] = Variable<int>(myTeamIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('actualRound: $actualRound, ')
          ..write('pointsToWin: $pointsToWin, ')
          ..write('createdAt: $createdAt, ')
          ..write('winnerTeamName: $winnerTeamName, ')
          ..write('myTeamIndex: $myTeamIndex')
          ..write(')'))
        .toString();
  }
}

class $TeamsTable extends Teams with TableInfo<$TeamsTable, TeamRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player1Meta = const VerificationMeta(
    'player1',
  );
  @override
  late final GeneratedColumn<String> player1 = GeneratedColumn<String>(
    'player1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _player2Meta = const VerificationMeta(
    'player2',
  );
  @override
  late final GeneratedColumn<String> player2 = GeneratedColumn<String>(
    'player2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
    'total_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    name,
    player1,
    player2,
    totalScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeamRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('player1')) {
      context.handle(
        _player1Meta,
        player1.isAcceptableOrUnknown(data['player1']!, _player1Meta),
      );
    }
    if (data.containsKey('player2')) {
      context.handle(
        _player2Meta,
        player2.isAcceptableOrUnknown(data['player2']!, _player2Meta),
      );
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_totalScoreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeamRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeamRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      player1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player1'],
      ),
      player2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player2'],
      ),
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_score'],
      )!,
    );
  }

  @override
  $TeamsTable createAlias(String alias) {
    return $TeamsTable(attachedDatabase, alias);
  }
}

class TeamRow extends DataClass implements Insertable<TeamRow> {
  final int id;
  final int gameId;
  final String name;
  final String? player1;
  final String? player2;
  final int totalScore;
  const TeamRow({
    required this.id,
    required this.gameId,
    required this.name,
    this.player1,
    this.player2,
    required this.totalScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || player1 != null) {
      map['player1'] = Variable<String>(player1);
    }
    if (!nullToAbsent || player2 != null) {
      map['player2'] = Variable<String>(player2);
    }
    map['total_score'] = Variable<int>(totalScore);
    return map;
  }

  TeamsCompanion toCompanion(bool nullToAbsent) {
    return TeamsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      name: Value(name),
      player1: player1 == null && nullToAbsent
          ? const Value.absent()
          : Value(player1),
      player2: player2 == null && nullToAbsent
          ? const Value.absent()
          : Value(player2),
      totalScore: Value(totalScore),
    );
  }

  factory TeamRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeamRow(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      name: serializer.fromJson<String>(json['name']),
      player1: serializer.fromJson<String?>(json['player1']),
      player2: serializer.fromJson<String?>(json['player2']),
      totalScore: serializer.fromJson<int>(json['totalScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'name': serializer.toJson<String>(name),
      'player1': serializer.toJson<String?>(player1),
      'player2': serializer.toJson<String?>(player2),
      'totalScore': serializer.toJson<int>(totalScore),
    };
  }

  TeamRow copyWith({
    int? id,
    int? gameId,
    String? name,
    Value<String?> player1 = const Value.absent(),
    Value<String?> player2 = const Value.absent(),
    int? totalScore,
  }) => TeamRow(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    name: name ?? this.name,
    player1: player1.present ? player1.value : this.player1,
    player2: player2.present ? player2.value : this.player2,
    totalScore: totalScore ?? this.totalScore,
  );
  TeamRow copyWithCompanion(TeamsCompanion data) {
    return TeamRow(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      name: data.name.present ? data.name.value : this.name,
      player1: data.player1.present ? data.player1.value : this.player1,
      player2: data.player2.present ? data.player2.value : this.player2,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeamRow(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name, ')
          ..write('player1: $player1, ')
          ..write('player2: $player2, ')
          ..write('totalScore: $totalScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, name, player1, player2, totalScore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeamRow &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.name == this.name &&
          other.player1 == this.player1 &&
          other.player2 == this.player2 &&
          other.totalScore == this.totalScore);
}

class TeamsCompanion extends UpdateCompanion<TeamRow> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<String> name;
  final Value<String?> player1;
  final Value<String?> player2;
  final Value<int> totalScore;
  const TeamsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.name = const Value.absent(),
    this.player1 = const Value.absent(),
    this.player2 = const Value.absent(),
    this.totalScore = const Value.absent(),
  });
  TeamsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required String name,
    this.player1 = const Value.absent(),
    this.player2 = const Value.absent(),
    required int totalScore,
  }) : gameId = Value(gameId),
       name = Value(name),
       totalScore = Value(totalScore);
  static Insertable<TeamRow> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<String>? name,
    Expression<String>? player1,
    Expression<String>? player2,
    Expression<int>? totalScore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (name != null) 'name': name,
      if (player1 != null) 'player1': player1,
      if (player2 != null) 'player2': player2,
      if (totalScore != null) 'total_score': totalScore,
    });
  }

  TeamsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<String>? name,
    Value<String?>? player1,
    Value<String?>? player2,
    Value<int>? totalScore,
  }) {
    return TeamsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      name: name ?? this.name,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      totalScore: totalScore ?? this.totalScore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (player1.present) {
      map['player1'] = Variable<String>(player1.value);
    }
    if (player2.present) {
      map['player2'] = Variable<String>(player2.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name, ')
          ..write('player1: $player1, ')
          ..write('player2: $player2, ')
          ..write('totalScore: $totalScore')
          ..write(')'))
        .toString();
  }
}

class $RoundsTable extends Rounds with TableInfo<$RoundsTable, RoundRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _team1PointsMeta = const VerificationMeta(
    'team1Points',
  );
  @override
  late final GeneratedColumn<int> team1Points = GeneratedColumn<int>(
    'team1_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _team2PointsMeta = const VerificationMeta(
    'team2Points',
  );
  @override
  late final GeneratedColumn<int> team2Points = GeneratedColumn<int>(
    'team2_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _team3PointsMeta = const VerificationMeta(
    'team3Points',
  );
  @override
  late final GeneratedColumn<int> team3Points = GeneratedColumn<int>(
    'team3_points',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _team4PointsMeta = const VerificationMeta(
    'team4Points',
  );
  @override
  late final GeneratedColumn<int> team4Points = GeneratedColumn<int>(
    'team4_points',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventsJsonMeta = const VerificationMeta(
    'eventsJson',
  );
  @override
  late final GeneratedColumn<String> eventsJson = GeneratedColumn<String>(
    'events_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    number,
    team1Points,
    team2Points,
    team3Points,
    team4Points,
    eventsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoundRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('team1_points')) {
      context.handle(
        _team1PointsMeta,
        team1Points.isAcceptableOrUnknown(
          data['team1_points']!,
          _team1PointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_team1PointsMeta);
    }
    if (data.containsKey('team2_points')) {
      context.handle(
        _team2PointsMeta,
        team2Points.isAcceptableOrUnknown(
          data['team2_points']!,
          _team2PointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_team2PointsMeta);
    }
    if (data.containsKey('team3_points')) {
      context.handle(
        _team3PointsMeta,
        team3Points.isAcceptableOrUnknown(
          data['team3_points']!,
          _team3PointsMeta,
        ),
      );
    }
    if (data.containsKey('team4_points')) {
      context.handle(
        _team4PointsMeta,
        team4Points.isAcceptableOrUnknown(
          data['team4_points']!,
          _team4PointsMeta,
        ),
      );
    }
    if (data.containsKey('events_json')) {
      context.handle(
        _eventsJsonMeta,
        eventsJson.isAcceptableOrUnknown(data['events_json']!, _eventsJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoundRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoundRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      team1Points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team1_points'],
      )!,
      team2Points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team2_points'],
      )!,
      team3Points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team3_points'],
      ),
      team4Points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team4_points'],
      ),
      eventsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}events_json'],
      ),
    );
  }

  @override
  $RoundsTable createAlias(String alias) {
    return $RoundsTable(attachedDatabase, alias);
  }
}

class RoundRow extends DataClass implements Insertable<RoundRow> {
  final int id;
  final int gameId;
  final int number;
  final int team1Points;
  final int team2Points;
  final int? team3Points;
  final int? team4Points;

  /// Acciones de la ronda (capicúa, pase redondo, trancao, zapatero, pase
  /// individual) serializadas como JSON.
  final String? eventsJson;
  const RoundRow({
    required this.id,
    required this.gameId,
    required this.number,
    required this.team1Points,
    required this.team2Points,
    this.team3Points,
    this.team4Points,
    this.eventsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['number'] = Variable<int>(number);
    map['team1_points'] = Variable<int>(team1Points);
    map['team2_points'] = Variable<int>(team2Points);
    if (!nullToAbsent || team3Points != null) {
      map['team3_points'] = Variable<int>(team3Points);
    }
    if (!nullToAbsent || team4Points != null) {
      map['team4_points'] = Variable<int>(team4Points);
    }
    if (!nullToAbsent || eventsJson != null) {
      map['events_json'] = Variable<String>(eventsJson);
    }
    return map;
  }

  RoundsCompanion toCompanion(bool nullToAbsent) {
    return RoundsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      number: Value(number),
      team1Points: Value(team1Points),
      team2Points: Value(team2Points),
      team3Points: team3Points == null && nullToAbsent
          ? const Value.absent()
          : Value(team3Points),
      team4Points: team4Points == null && nullToAbsent
          ? const Value.absent()
          : Value(team4Points),
      eventsJson: eventsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(eventsJson),
    );
  }

  factory RoundRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoundRow(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      number: serializer.fromJson<int>(json['number']),
      team1Points: serializer.fromJson<int>(json['team1Points']),
      team2Points: serializer.fromJson<int>(json['team2Points']),
      team3Points: serializer.fromJson<int?>(json['team3Points']),
      team4Points: serializer.fromJson<int?>(json['team4Points']),
      eventsJson: serializer.fromJson<String?>(json['eventsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'number': serializer.toJson<int>(number),
      'team1Points': serializer.toJson<int>(team1Points),
      'team2Points': serializer.toJson<int>(team2Points),
      'team3Points': serializer.toJson<int?>(team3Points),
      'team4Points': serializer.toJson<int?>(team4Points),
      'eventsJson': serializer.toJson<String?>(eventsJson),
    };
  }

  RoundRow copyWith({
    int? id,
    int? gameId,
    int? number,
    int? team1Points,
    int? team2Points,
    Value<int?> team3Points = const Value.absent(),
    Value<int?> team4Points = const Value.absent(),
    Value<String?> eventsJson = const Value.absent(),
  }) => RoundRow(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    number: number ?? this.number,
    team1Points: team1Points ?? this.team1Points,
    team2Points: team2Points ?? this.team2Points,
    team3Points: team3Points.present ? team3Points.value : this.team3Points,
    team4Points: team4Points.present ? team4Points.value : this.team4Points,
    eventsJson: eventsJson.present ? eventsJson.value : this.eventsJson,
  );
  RoundRow copyWithCompanion(RoundsCompanion data) {
    return RoundRow(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      number: data.number.present ? data.number.value : this.number,
      team1Points: data.team1Points.present
          ? data.team1Points.value
          : this.team1Points,
      team2Points: data.team2Points.present
          ? data.team2Points.value
          : this.team2Points,
      team3Points: data.team3Points.present
          ? data.team3Points.value
          : this.team3Points,
      team4Points: data.team4Points.present
          ? data.team4Points.value
          : this.team4Points,
      eventsJson: data.eventsJson.present
          ? data.eventsJson.value
          : this.eventsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoundRow(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('number: $number, ')
          ..write('team1Points: $team1Points, ')
          ..write('team2Points: $team2Points, ')
          ..write('team3Points: $team3Points, ')
          ..write('team4Points: $team4Points, ')
          ..write('eventsJson: $eventsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    number,
    team1Points,
    team2Points,
    team3Points,
    team4Points,
    eventsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoundRow &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.number == this.number &&
          other.team1Points == this.team1Points &&
          other.team2Points == this.team2Points &&
          other.team3Points == this.team3Points &&
          other.team4Points == this.team4Points &&
          other.eventsJson == this.eventsJson);
}

class RoundsCompanion extends UpdateCompanion<RoundRow> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<int> number;
  final Value<int> team1Points;
  final Value<int> team2Points;
  final Value<int?> team3Points;
  final Value<int?> team4Points;
  final Value<String?> eventsJson;
  const RoundsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.number = const Value.absent(),
    this.team1Points = const Value.absent(),
    this.team2Points = const Value.absent(),
    this.team3Points = const Value.absent(),
    this.team4Points = const Value.absent(),
    this.eventsJson = const Value.absent(),
  });
  RoundsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required int number,
    required int team1Points,
    required int team2Points,
    this.team3Points = const Value.absent(),
    this.team4Points = const Value.absent(),
    this.eventsJson = const Value.absent(),
  }) : gameId = Value(gameId),
       number = Value(number),
       team1Points = Value(team1Points),
       team2Points = Value(team2Points);
  static Insertable<RoundRow> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<int>? number,
    Expression<int>? team1Points,
    Expression<int>? team2Points,
    Expression<int>? team3Points,
    Expression<int>? team4Points,
    Expression<String>? eventsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (number != null) 'number': number,
      if (team1Points != null) 'team1_points': team1Points,
      if (team2Points != null) 'team2_points': team2Points,
      if (team3Points != null) 'team3_points': team3Points,
      if (team4Points != null) 'team4_points': team4Points,
      if (eventsJson != null) 'events_json': eventsJson,
    });
  }

  RoundsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<int>? number,
    Value<int>? team1Points,
    Value<int>? team2Points,
    Value<int?>? team3Points,
    Value<int?>? team4Points,
    Value<String?>? eventsJson,
  }) {
    return RoundsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      number: number ?? this.number,
      team1Points: team1Points ?? this.team1Points,
      team2Points: team2Points ?? this.team2Points,
      team3Points: team3Points ?? this.team3Points,
      team4Points: team4Points ?? this.team4Points,
      eventsJson: eventsJson ?? this.eventsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (team1Points.present) {
      map['team1_points'] = Variable<int>(team1Points.value);
    }
    if (team2Points.present) {
      map['team2_points'] = Variable<int>(team2Points.value);
    }
    if (team3Points.present) {
      map['team3_points'] = Variable<int>(team3Points.value);
    }
    if (team4Points.present) {
      map['team4_points'] = Variable<int>(team4Points.value);
    }
    if (eventsJson.present) {
      map['events_json'] = Variable<String>(eventsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoundsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('number: $number, ')
          ..write('team1Points: $team1Points, ')
          ..write('team2Points: $team2Points, ')
          ..write('team3Points: $team3Points, ')
          ..write('team4Points: $team4Points, ')
          ..write('eventsJson: $eventsJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $TeamsTable teams = $TeamsTable(this);
  late final $RoundsTable rounds = $RoundsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [games, teams, rounds];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('teams', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rounds', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      required int actualRound,
      required int pointsToWin,
      required DateTime createdAt,
      Value<String?> winnerTeamName,
      Value<int?> myTeamIndex,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      Value<int> actualRound,
      Value<int> pointsToWin,
      Value<DateTime> createdAt,
      Value<String?> winnerTeamName,
      Value<int?> myTeamIndex,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, GameRow> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TeamsTable, List<TeamRow>> _teamsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.teams,
    aliasName: $_aliasNameGenerator(db.games.id, db.teams.gameId),
  );

  $$TeamsTableProcessedTableManager get teamsRefs {
    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_teamsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoundsTable, List<RoundRow>> _roundsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rounds,
    aliasName: $_aliasNameGenerator(db.games.id, db.rounds.gameId),
  );

  $$RoundsTableProcessedTableManager get roundsRefs {
    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roundsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualRound => $composableBuilder(
    column: $table.actualRound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsToWin => $composableBuilder(
    column: $table.pointsToWin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get winnerTeamName => $composableBuilder(
    column: $table.winnerTeamName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get myTeamIndex => $composableBuilder(
    column: $table.myTeamIndex,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> teamsRefs(
    Expression<bool> Function($$TeamsTableFilterComposer f) f,
  ) {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> roundsRefs(
    Expression<bool> Function($$RoundsTableFilterComposer f) f,
  ) {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualRound => $composableBuilder(
    column: $table.actualRound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsToWin => $composableBuilder(
    column: $table.pointsToWin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get winnerTeamName => $composableBuilder(
    column: $table.winnerTeamName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get myTeamIndex => $composableBuilder(
    column: $table.myTeamIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get actualRound => $composableBuilder(
    column: $table.actualRound,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointsToWin => $composableBuilder(
    column: $table.pointsToWin,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get winnerTeamName => $composableBuilder(
    column: $table.winnerTeamName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get myTeamIndex => $composableBuilder(
    column: $table.myTeamIndex,
    builder: (column) => column,
  );

  Expression<T> teamsRefs<T extends Object>(
    Expression<T> Function($$TeamsTableAnnotationComposer a) f,
  ) {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> roundsRefs<T extends Object>(
    Expression<T> Function($$RoundsTableAnnotationComposer a) f,
  ) {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          GameRow,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (GameRow, $$GamesTableReferences),
          GameRow,
          PrefetchHooks Function({bool teamsRefs, bool roundsRefs})
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> actualRound = const Value.absent(),
                Value<int> pointsToWin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> winnerTeamName = const Value.absent(),
                Value<int?> myTeamIndex = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                actualRound: actualRound,
                pointsToWin: pointsToWin,
                createdAt: createdAt,
                winnerTeamName: winnerTeamName,
                myTeamIndex: myTeamIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int actualRound,
                required int pointsToWin,
                required DateTime createdAt,
                Value<String?> winnerTeamName = const Value.absent(),
                Value<int?> myTeamIndex = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                actualRound: actualRound,
                pointsToWin: pointsToWin,
                createdAt: createdAt,
                winnerTeamName: winnerTeamName,
                myTeamIndex: myTeamIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({teamsRefs = false, roundsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (teamsRefs) db.teams,
                if (roundsRefs) db.rounds,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (teamsRefs)
                    await $_getPrefetchedData<GameRow, $GamesTable, TeamRow>(
                      currentTable: table,
                      referencedTable: $$GamesTableReferences._teamsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$GamesTableReferences(db, table, p0).teamsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.gameId == item.id),
                      typedResults: items,
                    ),
                  if (roundsRefs)
                    await $_getPrefetchedData<GameRow, $GamesTable, RoundRow>(
                      currentTable: table,
                      referencedTable: $$GamesTableReferences._roundsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$GamesTableReferences(db, table, p0).roundsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.gameId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      GameRow,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (GameRow, $$GamesTableReferences),
      GameRow,
      PrefetchHooks Function({bool teamsRefs, bool roundsRefs})
    >;
typedef $$TeamsTableCreateCompanionBuilder =
    TeamsCompanion Function({
      Value<int> id,
      required int gameId,
      required String name,
      Value<String?> player1,
      Value<String?> player2,
      required int totalScore,
    });
typedef $$TeamsTableUpdateCompanionBuilder =
    TeamsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<String> name,
      Value<String?> player1,
      Value<String?> player2,
      Value<int> totalScore,
    });

final class $$TeamsTableReferences
    extends BaseReferences<_$AppDatabase, $TeamsTable, TeamRow> {
  $$TeamsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias($_aliasNameGenerator(db.teams.gameId, db.games.id));

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TeamsTableFilterComposer extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get player1 => $composableBuilder(
    column: $table.player1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get player2 => $composableBuilder(
    column: $table.player2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get player1 => $composableBuilder(
    column: $table.player1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get player2 => $composableBuilder(
    column: $table.player2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get player1 =>
      $composableBuilder(column: $table.player1, builder: (column) => column);

  GeneratedColumn<String> get player2 =>
      $composableBuilder(column: $table.player2, builder: (column) => column);

  GeneratedColumn<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamsTable,
          TeamRow,
          $$TeamsTableFilterComposer,
          $$TeamsTableOrderingComposer,
          $$TeamsTableAnnotationComposer,
          $$TeamsTableCreateCompanionBuilder,
          $$TeamsTableUpdateCompanionBuilder,
          (TeamRow, $$TeamsTableReferences),
          TeamRow,
          PrefetchHooks Function({bool gameId})
        > {
  $$TeamsTableTableManager(_$AppDatabase db, $TeamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> player1 = const Value.absent(),
                Value<String?> player2 = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
              }) => TeamsCompanion(
                id: id,
                gameId: gameId,
                name: name,
                player1: player1,
                player2: player2,
                totalScore: totalScore,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required String name,
                Value<String?> player1 = const Value.absent(),
                Value<String?> player2 = const Value.absent(),
                required int totalScore,
              }) => TeamsCompanion.insert(
                id: id,
                gameId: gameId,
                name: name,
                player1: player1,
                player2: player2,
                totalScore: totalScore,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TeamsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$TeamsTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$TeamsTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TeamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamsTable,
      TeamRow,
      $$TeamsTableFilterComposer,
      $$TeamsTableOrderingComposer,
      $$TeamsTableAnnotationComposer,
      $$TeamsTableCreateCompanionBuilder,
      $$TeamsTableUpdateCompanionBuilder,
      (TeamRow, $$TeamsTableReferences),
      TeamRow,
      PrefetchHooks Function({bool gameId})
    >;
typedef $$RoundsTableCreateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      required int gameId,
      required int number,
      required int team1Points,
      required int team2Points,
      Value<int?> team3Points,
      Value<int?> team4Points,
      Value<String?> eventsJson,
    });
typedef $$RoundsTableUpdateCompanionBuilder =
    RoundsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<int> number,
      Value<int> team1Points,
      Value<int> team2Points,
      Value<int?> team3Points,
      Value<int?> team4Points,
      Value<String?> eventsJson,
    });

final class $$RoundsTableReferences
    extends BaseReferences<_$AppDatabase, $RoundsTable, RoundRow> {
  $$RoundsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias($_aliasNameGenerator(db.rounds.gameId, db.games.id));

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoundsTableFilterComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get team1Points => $composableBuilder(
    column: $table.team1Points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get team2Points => $composableBuilder(
    column: $table.team2Points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get team3Points => $composableBuilder(
    column: $table.team3Points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get team4Points => $composableBuilder(
    column: $table.team4Points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventsJson => $composableBuilder(
    column: $table.eventsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get team1Points => $composableBuilder(
    column: $table.team1Points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get team2Points => $composableBuilder(
    column: $table.team2Points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get team3Points => $composableBuilder(
    column: $table.team3Points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get team4Points => $composableBuilder(
    column: $table.team4Points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventsJson => $composableBuilder(
    column: $table.eventsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<int> get team1Points => $composableBuilder(
    column: $table.team1Points,
    builder: (column) => column,
  );

  GeneratedColumn<int> get team2Points => $composableBuilder(
    column: $table.team2Points,
    builder: (column) => column,
  );

  GeneratedColumn<int> get team3Points => $composableBuilder(
    column: $table.team3Points,
    builder: (column) => column,
  );

  GeneratedColumn<int> get team4Points => $composableBuilder(
    column: $table.team4Points,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventsJson => $composableBuilder(
    column: $table.eventsJson,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoundsTable,
          RoundRow,
          $$RoundsTableFilterComposer,
          $$RoundsTableOrderingComposer,
          $$RoundsTableAnnotationComposer,
          $$RoundsTableCreateCompanionBuilder,
          $$RoundsTableUpdateCompanionBuilder,
          (RoundRow, $$RoundsTableReferences),
          RoundRow,
          PrefetchHooks Function({bool gameId})
        > {
  $$RoundsTableTableManager(_$AppDatabase db, $RoundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<int> team1Points = const Value.absent(),
                Value<int> team2Points = const Value.absent(),
                Value<int?> team3Points = const Value.absent(),
                Value<int?> team4Points = const Value.absent(),
                Value<String?> eventsJson = const Value.absent(),
              }) => RoundsCompanion(
                id: id,
                gameId: gameId,
                number: number,
                team1Points: team1Points,
                team2Points: team2Points,
                team3Points: team3Points,
                team4Points: team4Points,
                eventsJson: eventsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required int number,
                required int team1Points,
                required int team2Points,
                Value<int?> team3Points = const Value.absent(),
                Value<int?> team4Points = const Value.absent(),
                Value<String?> eventsJson = const Value.absent(),
              }) => RoundsCompanion.insert(
                id: id,
                gameId: gameId,
                number: number,
                team1Points: team1Points,
                team2Points: team2Points,
                team3Points: team3Points,
                team4Points: team4Points,
                eventsJson: eventsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RoundsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$RoundsTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$RoundsTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoundsTable,
      RoundRow,
      $$RoundsTableFilterComposer,
      $$RoundsTableOrderingComposer,
      $$RoundsTableAnnotationComposer,
      $$RoundsTableCreateCompanionBuilder,
      $$RoundsTableUpdateCompanionBuilder,
      (RoundRow, $$RoundsTableReferences),
      RoundRow,
      PrefetchHooks Function({bool gameId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$TeamsTableTableManager get teams =>
      $$TeamsTableTableManager(_db, _db.teams);
  $$RoundsTableTableManager get rounds =>
      $$RoundsTableTableManager(_db, _db.rounds);
}
