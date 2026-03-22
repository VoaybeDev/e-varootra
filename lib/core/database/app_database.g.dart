// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomCompletMeta =
      const VerificationMeta('nomComplet');
  @override
  late final GeneratedColumn<String> nomComplet = GeneratedColumn<String>(
      'nom_complet', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _pseudoMeta = const VerificationMeta('pseudo');
  @override
  late final GeneratedColumn<String> pseudo = GeneratedColumn<String>(
      'pseudo', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _motDePasseHashMeta =
      const VerificationMeta('motDePasseHash');
  @override
  late final GeneratedColumn<String> motDePasseHash = GeneratedColumn<String>(
      'mot_de_passe_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('utilisateur'));
  static const VerificationMeta _approuveMeta =
      const VerificationMeta('approuve');
  @override
  late final GeneratedColumn<bool> approuve = GeneratedColumn<bool>(
      'approuve', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("approuve" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dateCreationMeta =
      const VerificationMeta('dateCreation');
  @override
  late final GeneratedColumn<DateTime> dateCreation = GeneratedColumn<DateTime>(
      'date_creation', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nomComplet, pseudo, motDePasseHash, role, approuve, dateCreation];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom_complet')) {
      context.handle(
          _nomCompletMeta,
          nomComplet.isAcceptableOrUnknown(
              data['nom_complet']!, _nomCompletMeta));
    } else if (isInserting) {
      context.missing(_nomCompletMeta);
    }
    if (data.containsKey('pseudo')) {
      context.handle(_pseudoMeta,
          pseudo.isAcceptableOrUnknown(data['pseudo']!, _pseudoMeta));
    } else if (isInserting) {
      context.missing(_pseudoMeta);
    }
    if (data.containsKey('mot_de_passe_hash')) {
      context.handle(
          _motDePasseHashMeta,
          motDePasseHash.isAcceptableOrUnknown(
              data['mot_de_passe_hash']!, _motDePasseHashMeta));
    } else if (isInserting) {
      context.missing(_motDePasseHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('approuve')) {
      context.handle(_approuveMeta,
          approuve.isAcceptableOrUnknown(data['approuve']!, _approuveMeta));
    }
    if (data.containsKey('date_creation')) {
      context.handle(
          _dateCreationMeta,
          dateCreation.isAcceptableOrUnknown(
              data['date_creation']!, _dateCreationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nomComplet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom_complet'])!,
      pseudo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pseudo'])!,
      motDePasseHash: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}mot_de_passe_hash'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      approuve: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}approuve'])!,
      dateCreation: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_creation'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String nomComplet;
  final String pseudo;
  final String motDePasseHash;
  final String role;
  final bool approuve;
  final DateTime dateCreation;
  const User(
      {required this.id,
      required this.nomComplet,
      required this.pseudo,
      required this.motDePasseHash,
      required this.role,
      required this.approuve,
      required this.dateCreation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom_complet'] = Variable<String>(nomComplet);
    map['pseudo'] = Variable<String>(pseudo);
    map['mot_de_passe_hash'] = Variable<String>(motDePasseHash);
    map['role'] = Variable<String>(role);
    map['approuve'] = Variable<bool>(approuve);
    map['date_creation'] = Variable<DateTime>(dateCreation);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      nomComplet: Value(nomComplet),
      pseudo: Value(pseudo),
      motDePasseHash: Value(motDePasseHash),
      role: Value(role),
      approuve: Value(approuve),
      dateCreation: Value(dateCreation),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      nomComplet: serializer.fromJson<String>(json['nomComplet']),
      pseudo: serializer.fromJson<String>(json['pseudo']),
      motDePasseHash: serializer.fromJson<String>(json['motDePasseHash']),
      role: serializer.fromJson<String>(json['role']),
      approuve: serializer.fromJson<bool>(json['approuve']),
      dateCreation: serializer.fromJson<DateTime>(json['dateCreation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomComplet': serializer.toJson<String>(nomComplet),
      'pseudo': serializer.toJson<String>(pseudo),
      'motDePasseHash': serializer.toJson<String>(motDePasseHash),
      'role': serializer.toJson<String>(role),
      'approuve': serializer.toJson<bool>(approuve),
      'dateCreation': serializer.toJson<DateTime>(dateCreation),
    };
  }

  User copyWith(
          {int? id,
          String? nomComplet,
          String? pseudo,
          String? motDePasseHash,
          String? role,
          bool? approuve,
          DateTime? dateCreation}) =>
      User(
        id: id ?? this.id,
        nomComplet: nomComplet ?? this.nomComplet,
        pseudo: pseudo ?? this.pseudo,
        motDePasseHash: motDePasseHash ?? this.motDePasseHash,
        role: role ?? this.role,
        approuve: approuve ?? this.approuve,
        dateCreation: dateCreation ?? this.dateCreation,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      nomComplet:
          data.nomComplet.present ? data.nomComplet.value : this.nomComplet,
      pseudo: data.pseudo.present ? data.pseudo.value : this.pseudo,
      motDePasseHash: data.motDePasseHash.present
          ? data.motDePasseHash.value
          : this.motDePasseHash,
      role: data.role.present ? data.role.value : this.role,
      approuve: data.approuve.present ? data.approuve.value : this.approuve,
      dateCreation: data.dateCreation.present
          ? data.dateCreation.value
          : this.dateCreation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('nomComplet: $nomComplet, ')
          ..write('pseudo: $pseudo, ')
          ..write('motDePasseHash: $motDePasseHash, ')
          ..write('role: $role, ')
          ..write('approuve: $approuve, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, nomComplet, pseudo, motDePasseHash, role, approuve, dateCreation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.nomComplet == this.nomComplet &&
          other.pseudo == this.pseudo &&
          other.motDePasseHash == this.motDePasseHash &&
          other.role == this.role &&
          other.approuve == this.approuve &&
          other.dateCreation == this.dateCreation);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> nomComplet;
  final Value<String> pseudo;
  final Value<String> motDePasseHash;
  final Value<String> role;
  final Value<bool> approuve;
  final Value<DateTime> dateCreation;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.nomComplet = const Value.absent(),
    this.pseudo = const Value.absent(),
    this.motDePasseHash = const Value.absent(),
    this.role = const Value.absent(),
    this.approuve = const Value.absent(),
    this.dateCreation = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String nomComplet,
    required String pseudo,
    required String motDePasseHash,
    this.role = const Value.absent(),
    this.approuve = const Value.absent(),
    this.dateCreation = const Value.absent(),
  })  : nomComplet = Value(nomComplet),
        pseudo = Value(pseudo),
        motDePasseHash = Value(motDePasseHash);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? nomComplet,
    Expression<String>? pseudo,
    Expression<String>? motDePasseHash,
    Expression<String>? role,
    Expression<bool>? approuve,
    Expression<DateTime>? dateCreation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomComplet != null) 'nom_complet': nomComplet,
      if (pseudo != null) 'pseudo': pseudo,
      if (motDePasseHash != null) 'mot_de_passe_hash': motDePasseHash,
      if (role != null) 'role': role,
      if (approuve != null) 'approuve': approuve,
      if (dateCreation != null) 'date_creation': dateCreation,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? nomComplet,
      Value<String>? pseudo,
      Value<String>? motDePasseHash,
      Value<String>? role,
      Value<bool>? approuve,
      Value<DateTime>? dateCreation}) {
    return UsersCompanion(
      id: id ?? this.id,
      nomComplet: nomComplet ?? this.nomComplet,
      pseudo: pseudo ?? this.pseudo,
      motDePasseHash: motDePasseHash ?? this.motDePasseHash,
      role: role ?? this.role,
      approuve: approuve ?? this.approuve,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomComplet.present) {
      map['nom_complet'] = Variable<String>(nomComplet.value);
    }
    if (pseudo.present) {
      map['pseudo'] = Variable<String>(pseudo.value);
    }
    if (motDePasseHash.present) {
      map['mot_de_passe_hash'] = Variable<String>(motDePasseHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (approuve.present) {
      map['approuve'] = Variable<bool>(approuve.value);
    }
    if (dateCreation.present) {
      map['date_creation'] = Variable<DateTime>(dateCreation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('nomComplet: $nomComplet, ')
          ..write('pseudo: $pseudo, ')
          ..write('motDePasseHash: $motDePasseHash, ')
          ..write('role: $role, ')
          ..write('approuve: $approuve, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomCompletMeta =
      const VerificationMeta('nomComplet');
  @override
  late final GeneratedColumn<String> nomComplet = GeneratedColumn<String>(
      'nom_complet', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _telephoneMeta =
      const VerificationMeta('telephone');
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
      'telephone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _adresseMeta =
      const VerificationMeta('adresse');
  @override
  late final GeneratedColumn<String> adresse = GeneratedColumn<String>(
      'adresse', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _cinMeta = const VerificationMeta('cin');
  @override
  late final GeneratedColumn<String> cin = GeneratedColumn<String>(
      'cin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoCinMeta =
      const VerificationMeta('photoCin');
  @override
  late final GeneratedColumn<String> photoCin = GeneratedColumn<String>(
      'photo_cin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
      'photo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actifMeta = const VerificationMeta('actif');
  @override
  late final GeneratedColumn<bool> actif = GeneratedColumn<bool>(
      'actif', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("actif" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _dateCreationMeta =
      const VerificationMeta('dateCreation');
  @override
  late final GeneratedColumn<DateTime> dateCreation = GeneratedColumn<DateTime>(
      'date_creation', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nomComplet,
        telephone,
        adresse,
        cin,
        photoCin,
        photo,
        actif,
        dateCreation
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(Insertable<Client> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom_complet')) {
      context.handle(
          _nomCompletMeta,
          nomComplet.isAcceptableOrUnknown(
              data['nom_complet']!, _nomCompletMeta));
    } else if (isInserting) {
      context.missing(_nomCompletMeta);
    }
    if (data.containsKey('telephone')) {
      context.handle(_telephoneMeta,
          telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta));
    }
    if (data.containsKey('adresse')) {
      context.handle(_adresseMeta,
          adresse.isAcceptableOrUnknown(data['adresse']!, _adresseMeta));
    }
    if (data.containsKey('cin')) {
      context.handle(
          _cinMeta, cin.isAcceptableOrUnknown(data['cin']!, _cinMeta));
    }
    if (data.containsKey('photo_cin')) {
      context.handle(_photoCinMeta,
          photoCin.isAcceptableOrUnknown(data['photo_cin']!, _photoCinMeta));
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    }
    if (data.containsKey('actif')) {
      context.handle(
          _actifMeta, actif.isAcceptableOrUnknown(data['actif']!, _actifMeta));
    }
    if (data.containsKey('date_creation')) {
      context.handle(
          _dateCreationMeta,
          dateCreation.isAcceptableOrUnknown(
              data['date_creation']!, _dateCreationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nomComplet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom_complet'])!,
      telephone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telephone'])!,
      adresse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}adresse'])!,
      cin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cin']),
      photoCin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_cin']),
      photo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo']),
      actif: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}actif'])!,
      dateCreation: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_creation'])!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final int id;
  final String nomComplet;
  final String telephone;
  final String adresse;
  final String? cin;
  final String? photoCin;
  final String? photo;
  final bool actif;
  final DateTime dateCreation;
  const Client(
      {required this.id,
      required this.nomComplet,
      required this.telephone,
      required this.adresse,
      this.cin,
      this.photoCin,
      this.photo,
      required this.actif,
      required this.dateCreation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom_complet'] = Variable<String>(nomComplet);
    map['telephone'] = Variable<String>(telephone);
    map['adresse'] = Variable<String>(adresse);
    if (!nullToAbsent || cin != null) {
      map['cin'] = Variable<String>(cin);
    }
    if (!nullToAbsent || photoCin != null) {
      map['photo_cin'] = Variable<String>(photoCin);
    }
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<String>(photo);
    }
    map['actif'] = Variable<bool>(actif);
    map['date_creation'] = Variable<DateTime>(dateCreation);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      nomComplet: Value(nomComplet),
      telephone: Value(telephone),
      adresse: Value(adresse),
      cin: cin == null && nullToAbsent ? const Value.absent() : Value(cin),
      photoCin: photoCin == null && nullToAbsent
          ? const Value.absent()
          : Value(photoCin),
      photo:
          photo == null && nullToAbsent ? const Value.absent() : Value(photo),
      actif: Value(actif),
      dateCreation: Value(dateCreation),
    );
  }

  factory Client.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<int>(json['id']),
      nomComplet: serializer.fromJson<String>(json['nomComplet']),
      telephone: serializer.fromJson<String>(json['telephone']),
      adresse: serializer.fromJson<String>(json['adresse']),
      cin: serializer.fromJson<String?>(json['cin']),
      photoCin: serializer.fromJson<String?>(json['photoCin']),
      photo: serializer.fromJson<String?>(json['photo']),
      actif: serializer.fromJson<bool>(json['actif']),
      dateCreation: serializer.fromJson<DateTime>(json['dateCreation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomComplet': serializer.toJson<String>(nomComplet),
      'telephone': serializer.toJson<String>(telephone),
      'adresse': serializer.toJson<String>(adresse),
      'cin': serializer.toJson<String?>(cin),
      'photoCin': serializer.toJson<String?>(photoCin),
      'photo': serializer.toJson<String?>(photo),
      'actif': serializer.toJson<bool>(actif),
      'dateCreation': serializer.toJson<DateTime>(dateCreation),
    };
  }

  Client copyWith(
          {int? id,
          String? nomComplet,
          String? telephone,
          String? adresse,
          Value<String?> cin = const Value.absent(),
          Value<String?> photoCin = const Value.absent(),
          Value<String?> photo = const Value.absent(),
          bool? actif,
          DateTime? dateCreation}) =>
      Client(
        id: id ?? this.id,
        nomComplet: nomComplet ?? this.nomComplet,
        telephone: telephone ?? this.telephone,
        adresse: adresse ?? this.adresse,
        cin: cin.present ? cin.value : this.cin,
        photoCin: photoCin.present ? photoCin.value : this.photoCin,
        photo: photo.present ? photo.value : this.photo,
        actif: actif ?? this.actif,
        dateCreation: dateCreation ?? this.dateCreation,
      );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      nomComplet:
          data.nomComplet.present ? data.nomComplet.value : this.nomComplet,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      adresse: data.adresse.present ? data.adresse.value : this.adresse,
      cin: data.cin.present ? data.cin.value : this.cin,
      photoCin: data.photoCin.present ? data.photoCin.value : this.photoCin,
      photo: data.photo.present ? data.photo.value : this.photo,
      actif: data.actif.present ? data.actif.value : this.actif,
      dateCreation: data.dateCreation.present
          ? data.dateCreation.value
          : this.dateCreation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('nomComplet: $nomComplet, ')
          ..write('telephone: $telephone, ')
          ..write('adresse: $adresse, ')
          ..write('cin: $cin, ')
          ..write('photoCin: $photoCin, ')
          ..write('photo: $photo, ')
          ..write('actif: $actif, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nomComplet, telephone, adresse, cin,
      photoCin, photo, actif, dateCreation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.nomComplet == this.nomComplet &&
          other.telephone == this.telephone &&
          other.adresse == this.adresse &&
          other.cin == this.cin &&
          other.photoCin == this.photoCin &&
          other.photo == this.photo &&
          other.actif == this.actif &&
          other.dateCreation == this.dateCreation);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<int> id;
  final Value<String> nomComplet;
  final Value<String> telephone;
  final Value<String> adresse;
  final Value<String?> cin;
  final Value<String?> photoCin;
  final Value<String?> photo;
  final Value<bool> actif;
  final Value<DateTime> dateCreation;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.nomComplet = const Value.absent(),
    this.telephone = const Value.absent(),
    this.adresse = const Value.absent(),
    this.cin = const Value.absent(),
    this.photoCin = const Value.absent(),
    this.photo = const Value.absent(),
    this.actif = const Value.absent(),
    this.dateCreation = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String nomComplet,
    this.telephone = const Value.absent(),
    this.adresse = const Value.absent(),
    this.cin = const Value.absent(),
    this.photoCin = const Value.absent(),
    this.photo = const Value.absent(),
    this.actif = const Value.absent(),
    this.dateCreation = const Value.absent(),
  }) : nomComplet = Value(nomComplet);
  static Insertable<Client> custom({
    Expression<int>? id,
    Expression<String>? nomComplet,
    Expression<String>? telephone,
    Expression<String>? adresse,
    Expression<String>? cin,
    Expression<String>? photoCin,
    Expression<String>? photo,
    Expression<bool>? actif,
    Expression<DateTime>? dateCreation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomComplet != null) 'nom_complet': nomComplet,
      if (telephone != null) 'telephone': telephone,
      if (adresse != null) 'adresse': adresse,
      if (cin != null) 'cin': cin,
      if (photoCin != null) 'photo_cin': photoCin,
      if (photo != null) 'photo': photo,
      if (actif != null) 'actif': actif,
      if (dateCreation != null) 'date_creation': dateCreation,
    });
  }

  ClientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? nomComplet,
      Value<String>? telephone,
      Value<String>? adresse,
      Value<String?>? cin,
      Value<String?>? photoCin,
      Value<String?>? photo,
      Value<bool>? actif,
      Value<DateTime>? dateCreation}) {
    return ClientsCompanion(
      id: id ?? this.id,
      nomComplet: nomComplet ?? this.nomComplet,
      telephone: telephone ?? this.telephone,
      adresse: adresse ?? this.adresse,
      cin: cin ?? this.cin,
      photoCin: photoCin ?? this.photoCin,
      photo: photo ?? this.photo,
      actif: actif ?? this.actif,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomComplet.present) {
      map['nom_complet'] = Variable<String>(nomComplet.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (adresse.present) {
      map['adresse'] = Variable<String>(adresse.value);
    }
    if (cin.present) {
      map['cin'] = Variable<String>(cin.value);
    }
    if (photoCin.present) {
      map['photo_cin'] = Variable<String>(photoCin.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (actif.present) {
      map['actif'] = Variable<bool>(actif.value);
    }
    if (dateCreation.present) {
      map['date_creation'] = Variable<DateTime>(dateCreation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('nomComplet: $nomComplet, ')
          ..write('telephone: $telephone, ')
          ..write('adresse: $adresse, ')
          ..write('cin: $cin, ')
          ..write('photoCin: $photoCin, ')
          ..write('photo: $photo, ')
          ..write('actif: $actif, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _actifMeta = const VerificationMeta('actif');
  @override
  late final GeneratedColumn<bool> actif = GeneratedColumn<bool>(
      'actif', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("actif" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _dateCreationMeta =
      const VerificationMeta('dateCreation');
  @override
  late final GeneratedColumn<DateTime> dateCreation = GeneratedColumn<DateTime>(
      'date_creation', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nom, description, actif, dateCreation];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('actif')) {
      context.handle(
          _actifMeta, actif.isAcceptableOrUnknown(data['actif']!, _actifMeta));
    }
    if (data.containsKey('date_creation')) {
      context.handle(
          _dateCreationMeta,
          dateCreation.isAcceptableOrUnknown(
              data['date_creation']!, _dateCreationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      actif: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}actif'])!,
      dateCreation: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_creation'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String nom;
  final String description;
  final bool actif;
  final DateTime dateCreation;
  const Product(
      {required this.id,
      required this.nom,
      required this.description,
      required this.actif,
      required this.dateCreation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom'] = Variable<String>(nom);
    map['description'] = Variable<String>(description);
    map['actif'] = Variable<bool>(actif);
    map['date_creation'] = Variable<DateTime>(dateCreation);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      nom: Value(nom),
      description: Value(description),
      actif: Value(actif),
      dateCreation: Value(dateCreation),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      nom: serializer.fromJson<String>(json['nom']),
      description: serializer.fromJson<String>(json['description']),
      actif: serializer.fromJson<bool>(json['actif']),
      dateCreation: serializer.fromJson<DateTime>(json['dateCreation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nom': serializer.toJson<String>(nom),
      'description': serializer.toJson<String>(description),
      'actif': serializer.toJson<bool>(actif),
      'dateCreation': serializer.toJson<DateTime>(dateCreation),
    };
  }

  Product copyWith(
          {int? id,
          String? nom,
          String? description,
          bool? actif,
          DateTime? dateCreation}) =>
      Product(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        description: description ?? this.description,
        actif: actif ?? this.actif,
        dateCreation: dateCreation ?? this.dateCreation,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      nom: data.nom.present ? data.nom.value : this.nom,
      description:
          data.description.present ? data.description.value : this.description,
      actif: data.actif.present ? data.actif.value : this.actif,
      dateCreation: data.dateCreation.present
          ? data.dateCreation.value
          : this.dateCreation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('description: $description, ')
          ..write('actif: $actif, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nom, description, actif, dateCreation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.nom == this.nom &&
          other.description == this.description &&
          other.actif == this.actif &&
          other.dateCreation == this.dateCreation);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> nom;
  final Value<String> description;
  final Value<bool> actif;
  final Value<DateTime> dateCreation;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.description = const Value.absent(),
    this.actif = const Value.absent(),
    this.dateCreation = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String nom,
    this.description = const Value.absent(),
    this.actif = const Value.absent(),
    this.dateCreation = const Value.absent(),
  }) : nom = Value(nom);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? nom,
    Expression<String>? description,
    Expression<bool>? actif,
    Expression<DateTime>? dateCreation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (description != null) 'description': description,
      if (actif != null) 'actif': actif,
      if (dateCreation != null) 'date_creation': dateCreation,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? nom,
      Value<String>? description,
      Value<bool>? actif,
      Value<DateTime>? dateCreation}) {
    return ProductsCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      actif: actif ?? this.actif,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (actif.present) {
      map['actif'] = Variable<bool>(actif.value);
    }
    if (dateCreation.present) {
      map['date_creation'] = Variable<DateTime>(dateCreation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('description: $description, ')
          ..write('actif: $actif, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _symboleMeta =
      const VerificationMeta('symbole');
  @override
  late final GeneratedColumn<String> symbole = GeneratedColumn<String>(
      'symbole', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _actifMeta = const VerificationMeta('actif');
  @override
  late final GeneratedColumn<bool> actif = GeneratedColumn<bool>(
      'actif', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("actif" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, nom, symbole, actif];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(Insertable<Unit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('symbole')) {
      context.handle(_symboleMeta,
          symbole.isAcceptableOrUnknown(data['symbole']!, _symboleMeta));
    }
    if (data.containsKey('actif')) {
      context.handle(
          _actifMeta, actif.isAcceptableOrUnknown(data['actif']!, _actifMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      symbole: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbole'])!,
      actif: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}actif'])!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final String nom;
  final String symbole;
  final bool actif;
  const Unit(
      {required this.id,
      required this.nom,
      required this.symbole,
      required this.actif});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nom'] = Variable<String>(nom);
    map['symbole'] = Variable<String>(symbole);
    map['actif'] = Variable<bool>(actif);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      nom: Value(nom),
      symbole: Value(symbole),
      actif: Value(actif),
    );
  }

  factory Unit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      nom: serializer.fromJson<String>(json['nom']),
      symbole: serializer.fromJson<String>(json['symbole']),
      actif: serializer.fromJson<bool>(json['actif']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nom': serializer.toJson<String>(nom),
      'symbole': serializer.toJson<String>(symbole),
      'actif': serializer.toJson<bool>(actif),
    };
  }

  Unit copyWith({int? id, String? nom, String? symbole, bool? actif}) => Unit(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        symbole: symbole ?? this.symbole,
        actif: actif ?? this.actif,
      );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      nom: data.nom.present ? data.nom.value : this.nom,
      symbole: data.symbole.present ? data.symbole.value : this.symbole,
      actif: data.actif.present ? data.actif.value : this.actif,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('symbole: $symbole, ')
          ..write('actif: $actif')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nom, symbole, actif);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.nom == this.nom &&
          other.symbole == this.symbole &&
          other.actif == this.actif);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<String> nom;
  final Value<String> symbole;
  final Value<bool> actif;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.symbole = const Value.absent(),
    this.actif = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required String nom,
    this.symbole = const Value.absent(),
    this.actif = const Value.absent(),
  }) : nom = Value(nom);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<String>? nom,
    Expression<String>? symbole,
    Expression<bool>? actif,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (symbole != null) 'symbole': symbole,
      if (actif != null) 'actif': actif,
    });
  }

  UnitsCompanion copyWith(
      {Value<int>? id,
      Value<String>? nom,
      Value<String>? symbole,
      Value<bool>? actif}) {
    return UnitsCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      symbole: symbole ?? this.symbole,
      actif: actif ?? this.actif,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (symbole.present) {
      map['symbole'] = Variable<String>(symbole.value);
    }
    if (actif.present) {
      map['actif'] = Variable<bool>(actif.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('symbole: $symbole, ')
          ..write('actif: $actif')
          ..write(')'))
        .toString();
  }
}

class $ProductUnitsTable extends ProductUnits
    with TableInfo<$ProductUnitsTable, ProductUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _produitIdMeta =
      const VerificationMeta('produitId');
  @override
  late final GeneratedColumn<int> produitId = GeneratedColumn<int>(
      'produit_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _uniteIdMeta =
      const VerificationMeta('uniteId');
  @override
  late final GeneratedColumn<int> uniteId = GeneratedColumn<int>(
      'unite_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES units (id)'));
  static const VerificationMeta _prixUnitaireMeta =
      const VerificationMeta('prixUnitaire');
  @override
  late final GeneratedColumn<double> prixUnitaire = GeneratedColumn<double>(
      'prix_unitaire', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _actifMeta = const VerificationMeta('actif');
  @override
  late final GeneratedColumn<bool> actif = GeneratedColumn<bool>(
      'actif', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("actif" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _dateModificationMeta =
      const VerificationMeta('dateModification');
  @override
  late final GeneratedColumn<DateTime> dateModification =
      GeneratedColumn<DateTime>('date_modification', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, produitId, uniteId, prixUnitaire, actif, dateModification];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_units';
  @override
  VerificationContext validateIntegrity(Insertable<ProductUnit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('produit_id')) {
      context.handle(_produitIdMeta,
          produitId.isAcceptableOrUnknown(data['produit_id']!, _produitIdMeta));
    } else if (isInserting) {
      context.missing(_produitIdMeta);
    }
    if (data.containsKey('unite_id')) {
      context.handle(_uniteIdMeta,
          uniteId.isAcceptableOrUnknown(data['unite_id']!, _uniteIdMeta));
    } else if (isInserting) {
      context.missing(_uniteIdMeta);
    }
    if (data.containsKey('prix_unitaire')) {
      context.handle(
          _prixUnitaireMeta,
          prixUnitaire.isAcceptableOrUnknown(
              data['prix_unitaire']!, _prixUnitaireMeta));
    }
    if (data.containsKey('actif')) {
      context.handle(
          _actifMeta, actif.isAcceptableOrUnknown(data['actif']!, _actifMeta));
    }
    if (data.containsKey('date_modification')) {
      context.handle(
          _dateModificationMeta,
          dateModification.isAcceptableOrUnknown(
              data['date_modification']!, _dateModificationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {produitId, uniteId},
      ];
  @override
  ProductUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductUnit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      produitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}produit_id'])!,
      uniteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unite_id'])!,
      prixUnitaire: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}prix_unitaire'])!,
      actif: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}actif'])!,
      dateModification: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_modification'])!,
    );
  }

  @override
  $ProductUnitsTable createAlias(String alias) {
    return $ProductUnitsTable(attachedDatabase, alias);
  }
}

class ProductUnit extends DataClass implements Insertable<ProductUnit> {
  final int id;
  final int produitId;
  final int uniteId;
  final double prixUnitaire;
  final bool actif;
  final DateTime dateModification;
  const ProductUnit(
      {required this.id,
      required this.produitId,
      required this.uniteId,
      required this.prixUnitaire,
      required this.actif,
      required this.dateModification});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['produit_id'] = Variable<int>(produitId);
    map['unite_id'] = Variable<int>(uniteId);
    map['prix_unitaire'] = Variable<double>(prixUnitaire);
    map['actif'] = Variable<bool>(actif);
    map['date_modification'] = Variable<DateTime>(dateModification);
    return map;
  }

  ProductUnitsCompanion toCompanion(bool nullToAbsent) {
    return ProductUnitsCompanion(
      id: Value(id),
      produitId: Value(produitId),
      uniteId: Value(uniteId),
      prixUnitaire: Value(prixUnitaire),
      actif: Value(actif),
      dateModification: Value(dateModification),
    );
  }

  factory ProductUnit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductUnit(
      id: serializer.fromJson<int>(json['id']),
      produitId: serializer.fromJson<int>(json['produitId']),
      uniteId: serializer.fromJson<int>(json['uniteId']),
      prixUnitaire: serializer.fromJson<double>(json['prixUnitaire']),
      actif: serializer.fromJson<bool>(json['actif']),
      dateModification: serializer.fromJson<DateTime>(json['dateModification']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'produitId': serializer.toJson<int>(produitId),
      'uniteId': serializer.toJson<int>(uniteId),
      'prixUnitaire': serializer.toJson<double>(prixUnitaire),
      'actif': serializer.toJson<bool>(actif),
      'dateModification': serializer.toJson<DateTime>(dateModification),
    };
  }

  ProductUnit copyWith(
          {int? id,
          int? produitId,
          int? uniteId,
          double? prixUnitaire,
          bool? actif,
          DateTime? dateModification}) =>
      ProductUnit(
        id: id ?? this.id,
        produitId: produitId ?? this.produitId,
        uniteId: uniteId ?? this.uniteId,
        prixUnitaire: prixUnitaire ?? this.prixUnitaire,
        actif: actif ?? this.actif,
        dateModification: dateModification ?? this.dateModification,
      );
  ProductUnit copyWithCompanion(ProductUnitsCompanion data) {
    return ProductUnit(
      id: data.id.present ? data.id.value : this.id,
      produitId: data.produitId.present ? data.produitId.value : this.produitId,
      uniteId: data.uniteId.present ? data.uniteId.value : this.uniteId,
      prixUnitaire: data.prixUnitaire.present
          ? data.prixUnitaire.value
          : this.prixUnitaire,
      actif: data.actif.present ? data.actif.value : this.actif,
      dateModification: data.dateModification.present
          ? data.dateModification.value
          : this.dateModification,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductUnit(')
          ..write('id: $id, ')
          ..write('produitId: $produitId, ')
          ..write('uniteId: $uniteId, ')
          ..write('prixUnitaire: $prixUnitaire, ')
          ..write('actif: $actif, ')
          ..write('dateModification: $dateModification')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, produitId, uniteId, prixUnitaire, actif, dateModification);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductUnit &&
          other.id == this.id &&
          other.produitId == this.produitId &&
          other.uniteId == this.uniteId &&
          other.prixUnitaire == this.prixUnitaire &&
          other.actif == this.actif &&
          other.dateModification == this.dateModification);
}

class ProductUnitsCompanion extends UpdateCompanion<ProductUnit> {
  final Value<int> id;
  final Value<int> produitId;
  final Value<int> uniteId;
  final Value<double> prixUnitaire;
  final Value<bool> actif;
  final Value<DateTime> dateModification;
  const ProductUnitsCompanion({
    this.id = const Value.absent(),
    this.produitId = const Value.absent(),
    this.uniteId = const Value.absent(),
    this.prixUnitaire = const Value.absent(),
    this.actif = const Value.absent(),
    this.dateModification = const Value.absent(),
  });
  ProductUnitsCompanion.insert({
    this.id = const Value.absent(),
    required int produitId,
    required int uniteId,
    this.prixUnitaire = const Value.absent(),
    this.actif = const Value.absent(),
    this.dateModification = const Value.absent(),
  })  : produitId = Value(produitId),
        uniteId = Value(uniteId);
  static Insertable<ProductUnit> custom({
    Expression<int>? id,
    Expression<int>? produitId,
    Expression<int>? uniteId,
    Expression<double>? prixUnitaire,
    Expression<bool>? actif,
    Expression<DateTime>? dateModification,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (produitId != null) 'produit_id': produitId,
      if (uniteId != null) 'unite_id': uniteId,
      if (prixUnitaire != null) 'prix_unitaire': prixUnitaire,
      if (actif != null) 'actif': actif,
      if (dateModification != null) 'date_modification': dateModification,
    });
  }

  ProductUnitsCompanion copyWith(
      {Value<int>? id,
      Value<int>? produitId,
      Value<int>? uniteId,
      Value<double>? prixUnitaire,
      Value<bool>? actif,
      Value<DateTime>? dateModification}) {
    return ProductUnitsCompanion(
      id: id ?? this.id,
      produitId: produitId ?? this.produitId,
      uniteId: uniteId ?? this.uniteId,
      prixUnitaire: prixUnitaire ?? this.prixUnitaire,
      actif: actif ?? this.actif,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (produitId.present) {
      map['produit_id'] = Variable<int>(produitId.value);
    }
    if (uniteId.present) {
      map['unite_id'] = Variable<int>(uniteId.value);
    }
    if (prixUnitaire.present) {
      map['prix_unitaire'] = Variable<double>(prixUnitaire.value);
    }
    if (actif.present) {
      map['actif'] = Variable<bool>(actif.value);
    }
    if (dateModification.present) {
      map['date_modification'] = Variable<DateTime>(dateModification.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductUnitsCompanion(')
          ..write('id: $id, ')
          ..write('produitId: $produitId, ')
          ..write('uniteId: $uniteId, ')
          ..write('prixUnitaire: $prixUnitaire, ')
          ..write('actif: $actif, ')
          ..write('dateModification: $dateModification')
          ..write(')'))
        .toString();
  }
}

class $PriceHistoryTable extends PriceHistory
    with TableInfo<$PriceHistoryTable, PriceHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _produitUniteIdMeta =
      const VerificationMeta('produitUniteId');
  @override
  late final GeneratedColumn<int> produitUniteId = GeneratedColumn<int>(
      'produit_unite_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES product_units (id)'));
  static const VerificationMeta _ancienPrixMeta =
      const VerificationMeta('ancienPrix');
  @override
  late final GeneratedColumn<double> ancienPrix = GeneratedColumn<double>(
      'ancien_prix', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _nouveauPrixMeta =
      const VerificationMeta('nouveauPrix');
  @override
  late final GeneratedColumn<double> nouveauPrix = GeneratedColumn<double>(
      'nouveau_prix', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _utilisateurIdMeta =
      const VerificationMeta('utilisateurId');
  @override
  late final GeneratedColumn<int> utilisateurId = GeneratedColumn<int>(
      'utilisateur_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _dateModificationMeta =
      const VerificationMeta('dateModification');
  @override
  late final GeneratedColumn<DateTime> dateModification =
      GeneratedColumn<DateTime>('date_modification', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        produitUniteId,
        ancienPrix,
        nouveauPrix,
        utilisateurId,
        dateModification
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_history';
  @override
  VerificationContext validateIntegrity(Insertable<PriceHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('produit_unite_id')) {
      context.handle(
          _produitUniteIdMeta,
          produitUniteId.isAcceptableOrUnknown(
              data['produit_unite_id']!, _produitUniteIdMeta));
    } else if (isInserting) {
      context.missing(_produitUniteIdMeta);
    }
    if (data.containsKey('ancien_prix')) {
      context.handle(
          _ancienPrixMeta,
          ancienPrix.isAcceptableOrUnknown(
              data['ancien_prix']!, _ancienPrixMeta));
    } else if (isInserting) {
      context.missing(_ancienPrixMeta);
    }
    if (data.containsKey('nouveau_prix')) {
      context.handle(
          _nouveauPrixMeta,
          nouveauPrix.isAcceptableOrUnknown(
              data['nouveau_prix']!, _nouveauPrixMeta));
    } else if (isInserting) {
      context.missing(_nouveauPrixMeta);
    }
    if (data.containsKey('utilisateur_id')) {
      context.handle(
          _utilisateurIdMeta,
          utilisateurId.isAcceptableOrUnknown(
              data['utilisateur_id']!, _utilisateurIdMeta));
    } else if (isInserting) {
      context.missing(_utilisateurIdMeta);
    }
    if (data.containsKey('date_modification')) {
      context.handle(
          _dateModificationMeta,
          dateModification.isAcceptableOrUnknown(
              data['date_modification']!, _dateModificationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      produitUniteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}produit_unite_id'])!,
      ancienPrix: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ancien_prix'])!,
      nouveauPrix: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}nouveau_prix'])!,
      utilisateurId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}utilisateur_id'])!,
      dateModification: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_modification'])!,
    );
  }

  @override
  $PriceHistoryTable createAlias(String alias) {
    return $PriceHistoryTable(attachedDatabase, alias);
  }
}

class PriceHistoryData extends DataClass
    implements Insertable<PriceHistoryData> {
  final int id;
  final int produitUniteId;
  final double ancienPrix;
  final double nouveauPrix;
  final int utilisateurId;
  final DateTime dateModification;
  const PriceHistoryData(
      {required this.id,
      required this.produitUniteId,
      required this.ancienPrix,
      required this.nouveauPrix,
      required this.utilisateurId,
      required this.dateModification});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['produit_unite_id'] = Variable<int>(produitUniteId);
    map['ancien_prix'] = Variable<double>(ancienPrix);
    map['nouveau_prix'] = Variable<double>(nouveauPrix);
    map['utilisateur_id'] = Variable<int>(utilisateurId);
    map['date_modification'] = Variable<DateTime>(dateModification);
    return map;
  }

  PriceHistoryCompanion toCompanion(bool nullToAbsent) {
    return PriceHistoryCompanion(
      id: Value(id),
      produitUniteId: Value(produitUniteId),
      ancienPrix: Value(ancienPrix),
      nouveauPrix: Value(nouveauPrix),
      utilisateurId: Value(utilisateurId),
      dateModification: Value(dateModification),
    );
  }

  factory PriceHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceHistoryData(
      id: serializer.fromJson<int>(json['id']),
      produitUniteId: serializer.fromJson<int>(json['produitUniteId']),
      ancienPrix: serializer.fromJson<double>(json['ancienPrix']),
      nouveauPrix: serializer.fromJson<double>(json['nouveauPrix']),
      utilisateurId: serializer.fromJson<int>(json['utilisateurId']),
      dateModification: serializer.fromJson<DateTime>(json['dateModification']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'produitUniteId': serializer.toJson<int>(produitUniteId),
      'ancienPrix': serializer.toJson<double>(ancienPrix),
      'nouveauPrix': serializer.toJson<double>(nouveauPrix),
      'utilisateurId': serializer.toJson<int>(utilisateurId),
      'dateModification': serializer.toJson<DateTime>(dateModification),
    };
  }

  PriceHistoryData copyWith(
          {int? id,
          int? produitUniteId,
          double? ancienPrix,
          double? nouveauPrix,
          int? utilisateurId,
          DateTime? dateModification}) =>
      PriceHistoryData(
        id: id ?? this.id,
        produitUniteId: produitUniteId ?? this.produitUniteId,
        ancienPrix: ancienPrix ?? this.ancienPrix,
        nouveauPrix: nouveauPrix ?? this.nouveauPrix,
        utilisateurId: utilisateurId ?? this.utilisateurId,
        dateModification: dateModification ?? this.dateModification,
      );
  PriceHistoryData copyWithCompanion(PriceHistoryCompanion data) {
    return PriceHistoryData(
      id: data.id.present ? data.id.value : this.id,
      produitUniteId: data.produitUniteId.present
          ? data.produitUniteId.value
          : this.produitUniteId,
      ancienPrix:
          data.ancienPrix.present ? data.ancienPrix.value : this.ancienPrix,
      nouveauPrix:
          data.nouveauPrix.present ? data.nouveauPrix.value : this.nouveauPrix,
      utilisateurId: data.utilisateurId.present
          ? data.utilisateurId.value
          : this.utilisateurId,
      dateModification: data.dateModification.present
          ? data.dateModification.value
          : this.dateModification,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryData(')
          ..write('id: $id, ')
          ..write('produitUniteId: $produitUniteId, ')
          ..write('ancienPrix: $ancienPrix, ')
          ..write('nouveauPrix: $nouveauPrix, ')
          ..write('utilisateurId: $utilisateurId, ')
          ..write('dateModification: $dateModification')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, produitUniteId, ancienPrix, nouveauPrix,
      utilisateurId, dateModification);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceHistoryData &&
          other.id == this.id &&
          other.produitUniteId == this.produitUniteId &&
          other.ancienPrix == this.ancienPrix &&
          other.nouveauPrix == this.nouveauPrix &&
          other.utilisateurId == this.utilisateurId &&
          other.dateModification == this.dateModification);
}

class PriceHistoryCompanion extends UpdateCompanion<PriceHistoryData> {
  final Value<int> id;
  final Value<int> produitUniteId;
  final Value<double> ancienPrix;
  final Value<double> nouveauPrix;
  final Value<int> utilisateurId;
  final Value<DateTime> dateModification;
  const PriceHistoryCompanion({
    this.id = const Value.absent(),
    this.produitUniteId = const Value.absent(),
    this.ancienPrix = const Value.absent(),
    this.nouveauPrix = const Value.absent(),
    this.utilisateurId = const Value.absent(),
    this.dateModification = const Value.absent(),
  });
  PriceHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int produitUniteId,
    required double ancienPrix,
    required double nouveauPrix,
    required int utilisateurId,
    this.dateModification = const Value.absent(),
  })  : produitUniteId = Value(produitUniteId),
        ancienPrix = Value(ancienPrix),
        nouveauPrix = Value(nouveauPrix),
        utilisateurId = Value(utilisateurId);
  static Insertable<PriceHistoryData> custom({
    Expression<int>? id,
    Expression<int>? produitUniteId,
    Expression<double>? ancienPrix,
    Expression<double>? nouveauPrix,
    Expression<int>? utilisateurId,
    Expression<DateTime>? dateModification,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (produitUniteId != null) 'produit_unite_id': produitUniteId,
      if (ancienPrix != null) 'ancien_prix': ancienPrix,
      if (nouveauPrix != null) 'nouveau_prix': nouveauPrix,
      if (utilisateurId != null) 'utilisateur_id': utilisateurId,
      if (dateModification != null) 'date_modification': dateModification,
    });
  }

  PriceHistoryCompanion copyWith(
      {Value<int>? id,
      Value<int>? produitUniteId,
      Value<double>? ancienPrix,
      Value<double>? nouveauPrix,
      Value<int>? utilisateurId,
      Value<DateTime>? dateModification}) {
    return PriceHistoryCompanion(
      id: id ?? this.id,
      produitUniteId: produitUniteId ?? this.produitUniteId,
      ancienPrix: ancienPrix ?? this.ancienPrix,
      nouveauPrix: nouveauPrix ?? this.nouveauPrix,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (produitUniteId.present) {
      map['produit_unite_id'] = Variable<int>(produitUniteId.value);
    }
    if (ancienPrix.present) {
      map['ancien_prix'] = Variable<double>(ancienPrix.value);
    }
    if (nouveauPrix.present) {
      map['nouveau_prix'] = Variable<double>(nouveauPrix.value);
    }
    if (utilisateurId.present) {
      map['utilisateur_id'] = Variable<int>(utilisateurId.value);
    }
    if (dateModification.present) {
      map['date_modification'] = Variable<DateTime>(dateModification.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryCompanion(')
          ..write('id: $id, ')
          ..write('produitUniteId: $produitUniteId, ')
          ..write('ancienPrix: $ancienPrix, ')
          ..write('nouveauPrix: $nouveauPrix, ')
          ..write('utilisateurId: $utilisateurId, ')
          ..write('dateModification: $dateModification')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _numeroFactureMeta =
      const VerificationMeta('numeroFacture');
  @override
  late final GeneratedColumn<String> numeroFacture = GeneratedColumn<String>(
      'numero_facture', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
      'client_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES clients (id)'));
  static const VerificationMeta _produitUniteIdMeta =
      const VerificationMeta('produitUniteId');
  @override
  late final GeneratedColumn<int> produitUniteId = GeneratedColumn<int>(
      'produit_unite_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES product_units (id)'));
  static const VerificationMeta _quantiteMeta =
      const VerificationMeta('quantite');
  @override
  late final GeneratedColumn<double> quantite = GeneratedColumn<double>(
      'quantite', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _prixUnitaireFigeMeta =
      const VerificationMeta('prixUnitaireFige');
  @override
  late final GeneratedColumn<double> prixUnitaireFige = GeneratedColumn<double>(
      'prix_unitaire_fige', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _montantTotalMeta =
      const VerificationMeta('montantTotal');
  @override
  late final GeneratedColumn<double> montantTotal = GeneratedColumn<double>(
      'montant_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _montantPayeMeta =
      const VerificationMeta('montantPaye');
  @override
  late final GeneratedColumn<double> montantPaye = GeneratedColumn<double>(
      'montant_paye', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _montantRestantMeta =
      const VerificationMeta('montantRestant');
  @override
  late final GeneratedColumn<double> montantRestant = GeneratedColumn<double>(
      'montant_restant', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _enregistreParMeta =
      const VerificationMeta('enregistrePar');
  @override
  late final GeneratedColumn<int> enregistrePar = GeneratedColumn<int>(
      'enregistre_par', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _dateDetteMeta =
      const VerificationMeta('dateDette');
  @override
  late final GeneratedColumn<DateTime> dateDette = GeneratedColumn<DateTime>(
      'date_dette', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateModificationMeta =
      const VerificationMeta('dateModification');
  @override
  late final GeneratedColumn<DateTime> dateModification =
      GeneratedColumn<DateTime>('date_modification', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        numeroFacture,
        clientId,
        produitUniteId,
        quantite,
        prixUnitaireFige,
        montantTotal,
        montantPaye,
        montantRestant,
        statut,
        enregistrePar,
        dateDette,
        dateModification
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(Insertable<Debt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('numero_facture')) {
      context.handle(
          _numeroFactureMeta,
          numeroFacture.isAcceptableOrUnknown(
              data['numero_facture']!, _numeroFactureMeta));
    } else if (isInserting) {
      context.missing(_numeroFactureMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('produit_unite_id')) {
      context.handle(
          _produitUniteIdMeta,
          produitUniteId.isAcceptableOrUnknown(
              data['produit_unite_id']!, _produitUniteIdMeta));
    } else if (isInserting) {
      context.missing(_produitUniteIdMeta);
    }
    if (data.containsKey('quantite')) {
      context.handle(_quantiteMeta,
          quantite.isAcceptableOrUnknown(data['quantite']!, _quantiteMeta));
    } else if (isInserting) {
      context.missing(_quantiteMeta);
    }
    if (data.containsKey('prix_unitaire_fige')) {
      context.handle(
          _prixUnitaireFigeMeta,
          prixUnitaireFige.isAcceptableOrUnknown(
              data['prix_unitaire_fige']!, _prixUnitaireFigeMeta));
    } else if (isInserting) {
      context.missing(_prixUnitaireFigeMeta);
    }
    if (data.containsKey('montant_total')) {
      context.handle(
          _montantTotalMeta,
          montantTotal.isAcceptableOrUnknown(
              data['montant_total']!, _montantTotalMeta));
    } else if (isInserting) {
      context.missing(_montantTotalMeta);
    }
    if (data.containsKey('montant_paye')) {
      context.handle(
          _montantPayeMeta,
          montantPaye.isAcceptableOrUnknown(
              data['montant_paye']!, _montantPayeMeta));
    }
    if (data.containsKey('montant_restant')) {
      context.handle(
          _montantRestantMeta,
          montantRestant.isAcceptableOrUnknown(
              data['montant_restant']!, _montantRestantMeta));
    } else if (isInserting) {
      context.missing(_montantRestantMeta);
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('enregistre_par')) {
      context.handle(
          _enregistreParMeta,
          enregistrePar.isAcceptableOrUnknown(
              data['enregistre_par']!, _enregistreParMeta));
    } else if (isInserting) {
      context.missing(_enregistreParMeta);
    }
    if (data.containsKey('date_dette')) {
      context.handle(_dateDetteMeta,
          dateDette.isAcceptableOrUnknown(data['date_dette']!, _dateDetteMeta));
    } else if (isInserting) {
      context.missing(_dateDetteMeta);
    }
    if (data.containsKey('date_modification')) {
      context.handle(
          _dateModificationMeta,
          dateModification.isAcceptableOrUnknown(
              data['date_modification']!, _dateModificationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      numeroFacture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero_facture'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}client_id'])!,
      produitUniteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}produit_unite_id'])!,
      quantite: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantite'])!,
      prixUnitaireFige: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}prix_unitaire_fige'])!,
      montantTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_total'])!,
      montantPaye: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_paye'])!,
      montantRestant: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}montant_restant'])!,
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      enregistrePar: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}enregistre_par'])!,
      dateDette: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_dette'])!,
      dateModification: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_modification'])!,
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class Debt extends DataClass implements Insertable<Debt> {
  final int id;
  final String numeroFacture;
  final int clientId;
  final int produitUniteId;
  final double quantite;
  final double prixUnitaireFige;
  final double montantTotal;
  final double montantPaye;
  final double montantRestant;
  final String statut;
  final int enregistrePar;
  final DateTime dateDette;
  final DateTime dateModification;
  const Debt(
      {required this.id,
      required this.numeroFacture,
      required this.clientId,
      required this.produitUniteId,
      required this.quantite,
      required this.prixUnitaireFige,
      required this.montantTotal,
      required this.montantPaye,
      required this.montantRestant,
      required this.statut,
      required this.enregistrePar,
      required this.dateDette,
      required this.dateModification});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['numero_facture'] = Variable<String>(numeroFacture);
    map['client_id'] = Variable<int>(clientId);
    map['produit_unite_id'] = Variable<int>(produitUniteId);
    map['quantite'] = Variable<double>(quantite);
    map['prix_unitaire_fige'] = Variable<double>(prixUnitaireFige);
    map['montant_total'] = Variable<double>(montantTotal);
    map['montant_paye'] = Variable<double>(montantPaye);
    map['montant_restant'] = Variable<double>(montantRestant);
    map['statut'] = Variable<String>(statut);
    map['enregistre_par'] = Variable<int>(enregistrePar);
    map['date_dette'] = Variable<DateTime>(dateDette);
    map['date_modification'] = Variable<DateTime>(dateModification);
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      numeroFacture: Value(numeroFacture),
      clientId: Value(clientId),
      produitUniteId: Value(produitUniteId),
      quantite: Value(quantite),
      prixUnitaireFige: Value(prixUnitaireFige),
      montantTotal: Value(montantTotal),
      montantPaye: Value(montantPaye),
      montantRestant: Value(montantRestant),
      statut: Value(statut),
      enregistrePar: Value(enregistrePar),
      dateDette: Value(dateDette),
      dateModification: Value(dateModification),
    );
  }

  factory Debt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      id: serializer.fromJson<int>(json['id']),
      numeroFacture: serializer.fromJson<String>(json['numeroFacture']),
      clientId: serializer.fromJson<int>(json['clientId']),
      produitUniteId: serializer.fromJson<int>(json['produitUniteId']),
      quantite: serializer.fromJson<double>(json['quantite']),
      prixUnitaireFige: serializer.fromJson<double>(json['prixUnitaireFige']),
      montantTotal: serializer.fromJson<double>(json['montantTotal']),
      montantPaye: serializer.fromJson<double>(json['montantPaye']),
      montantRestant: serializer.fromJson<double>(json['montantRestant']),
      statut: serializer.fromJson<String>(json['statut']),
      enregistrePar: serializer.fromJson<int>(json['enregistrePar']),
      dateDette: serializer.fromJson<DateTime>(json['dateDette']),
      dateModification: serializer.fromJson<DateTime>(json['dateModification']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'numeroFacture': serializer.toJson<String>(numeroFacture),
      'clientId': serializer.toJson<int>(clientId),
      'produitUniteId': serializer.toJson<int>(produitUniteId),
      'quantite': serializer.toJson<double>(quantite),
      'prixUnitaireFige': serializer.toJson<double>(prixUnitaireFige),
      'montantTotal': serializer.toJson<double>(montantTotal),
      'montantPaye': serializer.toJson<double>(montantPaye),
      'montantRestant': serializer.toJson<double>(montantRestant),
      'statut': serializer.toJson<String>(statut),
      'enregistrePar': serializer.toJson<int>(enregistrePar),
      'dateDette': serializer.toJson<DateTime>(dateDette),
      'dateModification': serializer.toJson<DateTime>(dateModification),
    };
  }

  Debt copyWith(
          {int? id,
          String? numeroFacture,
          int? clientId,
          int? produitUniteId,
          double? quantite,
          double? prixUnitaireFige,
          double? montantTotal,
          double? montantPaye,
          double? montantRestant,
          String? statut,
          int? enregistrePar,
          DateTime? dateDette,
          DateTime? dateModification}) =>
      Debt(
        id: id ?? this.id,
        numeroFacture: numeroFacture ?? this.numeroFacture,
        clientId: clientId ?? this.clientId,
        produitUniteId: produitUniteId ?? this.produitUniteId,
        quantite: quantite ?? this.quantite,
        prixUnitaireFige: prixUnitaireFige ?? this.prixUnitaireFige,
        montantTotal: montantTotal ?? this.montantTotal,
        montantPaye: montantPaye ?? this.montantPaye,
        montantRestant: montantRestant ?? this.montantRestant,
        statut: statut ?? this.statut,
        enregistrePar: enregistrePar ?? this.enregistrePar,
        dateDette: dateDette ?? this.dateDette,
        dateModification: dateModification ?? this.dateModification,
      );
  Debt copyWithCompanion(DebtsCompanion data) {
    return Debt(
      id: data.id.present ? data.id.value : this.id,
      numeroFacture: data.numeroFacture.present
          ? data.numeroFacture.value
          : this.numeroFacture,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      produitUniteId: data.produitUniteId.present
          ? data.produitUniteId.value
          : this.produitUniteId,
      quantite: data.quantite.present ? data.quantite.value : this.quantite,
      prixUnitaireFige: data.prixUnitaireFige.present
          ? data.prixUnitaireFige.value
          : this.prixUnitaireFige,
      montantTotal: data.montantTotal.present
          ? data.montantTotal.value
          : this.montantTotal,
      montantPaye:
          data.montantPaye.present ? data.montantPaye.value : this.montantPaye,
      montantRestant: data.montantRestant.present
          ? data.montantRestant.value
          : this.montantRestant,
      statut: data.statut.present ? data.statut.value : this.statut,
      enregistrePar: data.enregistrePar.present
          ? data.enregistrePar.value
          : this.enregistrePar,
      dateDette: data.dateDette.present ? data.dateDette.value : this.dateDette,
      dateModification: data.dateModification.present
          ? data.dateModification.value
          : this.dateModification,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('id: $id, ')
          ..write('numeroFacture: $numeroFacture, ')
          ..write('clientId: $clientId, ')
          ..write('produitUniteId: $produitUniteId, ')
          ..write('quantite: $quantite, ')
          ..write('prixUnitaireFige: $prixUnitaireFige, ')
          ..write('montantTotal: $montantTotal, ')
          ..write('montantPaye: $montantPaye, ')
          ..write('montantRestant: $montantRestant, ')
          ..write('statut: $statut, ')
          ..write('enregistrePar: $enregistrePar, ')
          ..write('dateDette: $dateDette, ')
          ..write('dateModification: $dateModification')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      numeroFacture,
      clientId,
      produitUniteId,
      quantite,
      prixUnitaireFige,
      montantTotal,
      montantPaye,
      montantRestant,
      statut,
      enregistrePar,
      dateDette,
      dateModification);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.id == this.id &&
          other.numeroFacture == this.numeroFacture &&
          other.clientId == this.clientId &&
          other.produitUniteId == this.produitUniteId &&
          other.quantite == this.quantite &&
          other.prixUnitaireFige == this.prixUnitaireFige &&
          other.montantTotal == this.montantTotal &&
          other.montantPaye == this.montantPaye &&
          other.montantRestant == this.montantRestant &&
          other.statut == this.statut &&
          other.enregistrePar == this.enregistrePar &&
          other.dateDette == this.dateDette &&
          other.dateModification == this.dateModification);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<int> id;
  final Value<String> numeroFacture;
  final Value<int> clientId;
  final Value<int> produitUniteId;
  final Value<double> quantite;
  final Value<double> prixUnitaireFige;
  final Value<double> montantTotal;
  final Value<double> montantPaye;
  final Value<double> montantRestant;
  final Value<String> statut;
  final Value<int> enregistrePar;
  final Value<DateTime> dateDette;
  final Value<DateTime> dateModification;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.numeroFacture = const Value.absent(),
    this.clientId = const Value.absent(),
    this.produitUniteId = const Value.absent(),
    this.quantite = const Value.absent(),
    this.prixUnitaireFige = const Value.absent(),
    this.montantTotal = const Value.absent(),
    this.montantPaye = const Value.absent(),
    this.montantRestant = const Value.absent(),
    this.statut = const Value.absent(),
    this.enregistrePar = const Value.absent(),
    this.dateDette = const Value.absent(),
    this.dateModification = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.id = const Value.absent(),
    required String numeroFacture,
    required int clientId,
    required int produitUniteId,
    required double quantite,
    required double prixUnitaireFige,
    required double montantTotal,
    this.montantPaye = const Value.absent(),
    required double montantRestant,
    this.statut = const Value.absent(),
    required int enregistrePar,
    required DateTime dateDette,
    this.dateModification = const Value.absent(),
  })  : numeroFacture = Value(numeroFacture),
        clientId = Value(clientId),
        produitUniteId = Value(produitUniteId),
        quantite = Value(quantite),
        prixUnitaireFige = Value(prixUnitaireFige),
        montantTotal = Value(montantTotal),
        montantRestant = Value(montantRestant),
        enregistrePar = Value(enregistrePar),
        dateDette = Value(dateDette);
  static Insertable<Debt> custom({
    Expression<int>? id,
    Expression<String>? numeroFacture,
    Expression<int>? clientId,
    Expression<int>? produitUniteId,
    Expression<double>? quantite,
    Expression<double>? prixUnitaireFige,
    Expression<double>? montantTotal,
    Expression<double>? montantPaye,
    Expression<double>? montantRestant,
    Expression<String>? statut,
    Expression<int>? enregistrePar,
    Expression<DateTime>? dateDette,
    Expression<DateTime>? dateModification,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numeroFacture != null) 'numero_facture': numeroFacture,
      if (clientId != null) 'client_id': clientId,
      if (produitUniteId != null) 'produit_unite_id': produitUniteId,
      if (quantite != null) 'quantite': quantite,
      if (prixUnitaireFige != null) 'prix_unitaire_fige': prixUnitaireFige,
      if (montantTotal != null) 'montant_total': montantTotal,
      if (montantPaye != null) 'montant_paye': montantPaye,
      if (montantRestant != null) 'montant_restant': montantRestant,
      if (statut != null) 'statut': statut,
      if (enregistrePar != null) 'enregistre_par': enregistrePar,
      if (dateDette != null) 'date_dette': dateDette,
      if (dateModification != null) 'date_modification': dateModification,
    });
  }

  DebtsCompanion copyWith(
      {Value<int>? id,
      Value<String>? numeroFacture,
      Value<int>? clientId,
      Value<int>? produitUniteId,
      Value<double>? quantite,
      Value<double>? prixUnitaireFige,
      Value<double>? montantTotal,
      Value<double>? montantPaye,
      Value<double>? montantRestant,
      Value<String>? statut,
      Value<int>? enregistrePar,
      Value<DateTime>? dateDette,
      Value<DateTime>? dateModification}) {
    return DebtsCompanion(
      id: id ?? this.id,
      numeroFacture: numeroFacture ?? this.numeroFacture,
      clientId: clientId ?? this.clientId,
      produitUniteId: produitUniteId ?? this.produitUniteId,
      quantite: quantite ?? this.quantite,
      prixUnitaireFige: prixUnitaireFige ?? this.prixUnitaireFige,
      montantTotal: montantTotal ?? this.montantTotal,
      montantPaye: montantPaye ?? this.montantPaye,
      montantRestant: montantRestant ?? this.montantRestant,
      statut: statut ?? this.statut,
      enregistrePar: enregistrePar ?? this.enregistrePar,
      dateDette: dateDette ?? this.dateDette,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (numeroFacture.present) {
      map['numero_facture'] = Variable<String>(numeroFacture.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (produitUniteId.present) {
      map['produit_unite_id'] = Variable<int>(produitUniteId.value);
    }
    if (quantite.present) {
      map['quantite'] = Variable<double>(quantite.value);
    }
    if (prixUnitaireFige.present) {
      map['prix_unitaire_fige'] = Variable<double>(prixUnitaireFige.value);
    }
    if (montantTotal.present) {
      map['montant_total'] = Variable<double>(montantTotal.value);
    }
    if (montantPaye.present) {
      map['montant_paye'] = Variable<double>(montantPaye.value);
    }
    if (montantRestant.present) {
      map['montant_restant'] = Variable<double>(montantRestant.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (enregistrePar.present) {
      map['enregistre_par'] = Variable<int>(enregistrePar.value);
    }
    if (dateDette.present) {
      map['date_dette'] = Variable<DateTime>(dateDette.value);
    }
    if (dateModification.present) {
      map['date_modification'] = Variable<DateTime>(dateModification.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('numeroFacture: $numeroFacture, ')
          ..write('clientId: $clientId, ')
          ..write('produitUniteId: $produitUniteId, ')
          ..write('quantite: $quantite, ')
          ..write('prixUnitaireFige: $prixUnitaireFige, ')
          ..write('montantTotal: $montantTotal, ')
          ..write('montantPaye: $montantPaye, ')
          ..write('montantRestant: $montantRestant, ')
          ..write('statut: $statut, ')
          ..write('enregistrePar: $enregistrePar, ')
          ..write('dateDette: $dateDette, ')
          ..write('dateModification: $dateModification')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _detteIdMeta =
      const VerificationMeta('detteId');
  @override
  late final GeneratedColumn<int> detteId = GeneratedColumn<int>(
      'dette_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES debts (id)'));
  static const VerificationMeta _montantPayeMeta =
      const VerificationMeta('montantPaye');
  @override
  late final GeneratedColumn<double> montantPaye = GeneratedColumn<double>(
      'montant_paye', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _modePaiementMeta =
      const VerificationMeta('modePaiement');
  @override
  late final GeneratedColumn<String> modePaiement = GeneratedColumn<String>(
      'mode_paiement', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Especes'));
  static const VerificationMeta _referencePaiementMeta =
      const VerificationMeta('referencePaiement');
  @override
  late final GeneratedColumn<String> referencePaiement =
      GeneratedColumn<String>('reference_paiement', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _enregistreParMeta =
      const VerificationMeta('enregistrePar');
  @override
  late final GeneratedColumn<int> enregistrePar = GeneratedColumn<int>(
      'enregistre_par', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _datePaiementMeta =
      const VerificationMeta('datePaiement');
  @override
  late final GeneratedColumn<DateTime> datePaiement = GeneratedColumn<DateTime>(
      'date_paiement', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateCreationMeta =
      const VerificationMeta('dateCreation');
  @override
  late final GeneratedColumn<DateTime> dateCreation = GeneratedColumn<DateTime>(
      'date_creation', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        detteId,
        montantPaye,
        modePaiement,
        referencePaiement,
        enregistrePar,
        datePaiement,
        dateCreation
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dette_id')) {
      context.handle(_detteIdMeta,
          detteId.isAcceptableOrUnknown(data['dette_id']!, _detteIdMeta));
    } else if (isInserting) {
      context.missing(_detteIdMeta);
    }
    if (data.containsKey('montant_paye')) {
      context.handle(
          _montantPayeMeta,
          montantPaye.isAcceptableOrUnknown(
              data['montant_paye']!, _montantPayeMeta));
    } else if (isInserting) {
      context.missing(_montantPayeMeta);
    }
    if (data.containsKey('mode_paiement')) {
      context.handle(
          _modePaiementMeta,
          modePaiement.isAcceptableOrUnknown(
              data['mode_paiement']!, _modePaiementMeta));
    }
    if (data.containsKey('reference_paiement')) {
      context.handle(
          _referencePaiementMeta,
          referencePaiement.isAcceptableOrUnknown(
              data['reference_paiement']!, _referencePaiementMeta));
    }
    if (data.containsKey('enregistre_par')) {
      context.handle(
          _enregistreParMeta,
          enregistrePar.isAcceptableOrUnknown(
              data['enregistre_par']!, _enregistreParMeta));
    } else if (isInserting) {
      context.missing(_enregistreParMeta);
    }
    if (data.containsKey('date_paiement')) {
      context.handle(
          _datePaiementMeta,
          datePaiement.isAcceptableOrUnknown(
              data['date_paiement']!, _datePaiementMeta));
    } else if (isInserting) {
      context.missing(_datePaiementMeta);
    }
    if (data.containsKey('date_creation')) {
      context.handle(
          _dateCreationMeta,
          dateCreation.isAcceptableOrUnknown(
              data['date_creation']!, _dateCreationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      detteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dette_id'])!,
      montantPaye: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}montant_paye'])!,
      modePaiement: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode_paiement'])!,
      referencePaiement: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_paiement'])!,
      enregistrePar: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}enregistre_par'])!,
      datePaiement: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_paiement'])!,
      dateCreation: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_creation'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int detteId;
  final double montantPaye;
  final String modePaiement;
  final String referencePaiement;
  final int enregistrePar;
  final DateTime datePaiement;
  final DateTime dateCreation;
  const Payment(
      {required this.id,
      required this.detteId,
      required this.montantPaye,
      required this.modePaiement,
      required this.referencePaiement,
      required this.enregistrePar,
      required this.datePaiement,
      required this.dateCreation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dette_id'] = Variable<int>(detteId);
    map['montant_paye'] = Variable<double>(montantPaye);
    map['mode_paiement'] = Variable<String>(modePaiement);
    map['reference_paiement'] = Variable<String>(referencePaiement);
    map['enregistre_par'] = Variable<int>(enregistrePar);
    map['date_paiement'] = Variable<DateTime>(datePaiement);
    map['date_creation'] = Variable<DateTime>(dateCreation);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      detteId: Value(detteId),
      montantPaye: Value(montantPaye),
      modePaiement: Value(modePaiement),
      referencePaiement: Value(referencePaiement),
      enregistrePar: Value(enregistrePar),
      datePaiement: Value(datePaiement),
      dateCreation: Value(dateCreation),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      detteId: serializer.fromJson<int>(json['detteId']),
      montantPaye: serializer.fromJson<double>(json['montantPaye']),
      modePaiement: serializer.fromJson<String>(json['modePaiement']),
      referencePaiement: serializer.fromJson<String>(json['referencePaiement']),
      enregistrePar: serializer.fromJson<int>(json['enregistrePar']),
      datePaiement: serializer.fromJson<DateTime>(json['datePaiement']),
      dateCreation: serializer.fromJson<DateTime>(json['dateCreation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'detteId': serializer.toJson<int>(detteId),
      'montantPaye': serializer.toJson<double>(montantPaye),
      'modePaiement': serializer.toJson<String>(modePaiement),
      'referencePaiement': serializer.toJson<String>(referencePaiement),
      'enregistrePar': serializer.toJson<int>(enregistrePar),
      'datePaiement': serializer.toJson<DateTime>(datePaiement),
      'dateCreation': serializer.toJson<DateTime>(dateCreation),
    };
  }

  Payment copyWith(
          {int? id,
          int? detteId,
          double? montantPaye,
          String? modePaiement,
          String? referencePaiement,
          int? enregistrePar,
          DateTime? datePaiement,
          DateTime? dateCreation}) =>
      Payment(
        id: id ?? this.id,
        detteId: detteId ?? this.detteId,
        montantPaye: montantPaye ?? this.montantPaye,
        modePaiement: modePaiement ?? this.modePaiement,
        referencePaiement: referencePaiement ?? this.referencePaiement,
        enregistrePar: enregistrePar ?? this.enregistrePar,
        datePaiement: datePaiement ?? this.datePaiement,
        dateCreation: dateCreation ?? this.dateCreation,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      detteId: data.detteId.present ? data.detteId.value : this.detteId,
      montantPaye:
          data.montantPaye.present ? data.montantPaye.value : this.montantPaye,
      modePaiement: data.modePaiement.present
          ? data.modePaiement.value
          : this.modePaiement,
      referencePaiement: data.referencePaiement.present
          ? data.referencePaiement.value
          : this.referencePaiement,
      enregistrePar: data.enregistrePar.present
          ? data.enregistrePar.value
          : this.enregistrePar,
      datePaiement: data.datePaiement.present
          ? data.datePaiement.value
          : this.datePaiement,
      dateCreation: data.dateCreation.present
          ? data.dateCreation.value
          : this.dateCreation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('detteId: $detteId, ')
          ..write('montantPaye: $montantPaye, ')
          ..write('modePaiement: $modePaiement, ')
          ..write('referencePaiement: $referencePaiement, ')
          ..write('enregistrePar: $enregistrePar, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, detteId, montantPaye, modePaiement,
      referencePaiement, enregistrePar, datePaiement, dateCreation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.detteId == this.detteId &&
          other.montantPaye == this.montantPaye &&
          other.modePaiement == this.modePaiement &&
          other.referencePaiement == this.referencePaiement &&
          other.enregistrePar == this.enregistrePar &&
          other.datePaiement == this.datePaiement &&
          other.dateCreation == this.dateCreation);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> detteId;
  final Value<double> montantPaye;
  final Value<String> modePaiement;
  final Value<String> referencePaiement;
  final Value<int> enregistrePar;
  final Value<DateTime> datePaiement;
  final Value<DateTime> dateCreation;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.detteId = const Value.absent(),
    this.montantPaye = const Value.absent(),
    this.modePaiement = const Value.absent(),
    this.referencePaiement = const Value.absent(),
    this.enregistrePar = const Value.absent(),
    this.datePaiement = const Value.absent(),
    this.dateCreation = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int detteId,
    required double montantPaye,
    this.modePaiement = const Value.absent(),
    this.referencePaiement = const Value.absent(),
    required int enregistrePar,
    required DateTime datePaiement,
    this.dateCreation = const Value.absent(),
  })  : detteId = Value(detteId),
        montantPaye = Value(montantPaye),
        enregistrePar = Value(enregistrePar),
        datePaiement = Value(datePaiement);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? detteId,
    Expression<double>? montantPaye,
    Expression<String>? modePaiement,
    Expression<String>? referencePaiement,
    Expression<int>? enregistrePar,
    Expression<DateTime>? datePaiement,
    Expression<DateTime>? dateCreation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (detteId != null) 'dette_id': detteId,
      if (montantPaye != null) 'montant_paye': montantPaye,
      if (modePaiement != null) 'mode_paiement': modePaiement,
      if (referencePaiement != null) 'reference_paiement': referencePaiement,
      if (enregistrePar != null) 'enregistre_par': enregistrePar,
      if (datePaiement != null) 'date_paiement': datePaiement,
      if (dateCreation != null) 'date_creation': dateCreation,
    });
  }

  PaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? detteId,
      Value<double>? montantPaye,
      Value<String>? modePaiement,
      Value<String>? referencePaiement,
      Value<int>? enregistrePar,
      Value<DateTime>? datePaiement,
      Value<DateTime>? dateCreation}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      detteId: detteId ?? this.detteId,
      montantPaye: montantPaye ?? this.montantPaye,
      modePaiement: modePaiement ?? this.modePaiement,
      referencePaiement: referencePaiement ?? this.referencePaiement,
      enregistrePar: enregistrePar ?? this.enregistrePar,
      datePaiement: datePaiement ?? this.datePaiement,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (detteId.present) {
      map['dette_id'] = Variable<int>(detteId.value);
    }
    if (montantPaye.present) {
      map['montant_paye'] = Variable<double>(montantPaye.value);
    }
    if (modePaiement.present) {
      map['mode_paiement'] = Variable<String>(modePaiement.value);
    }
    if (referencePaiement.present) {
      map['reference_paiement'] = Variable<String>(referencePaiement.value);
    }
    if (enregistrePar.present) {
      map['enregistre_par'] = Variable<int>(enregistrePar.value);
    }
    if (datePaiement.present) {
      map['date_paiement'] = Variable<DateTime>(datePaiement.value);
    }
    if (dateCreation.present) {
      map['date_creation'] = Variable<DateTime>(dateCreation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('detteId: $detteId, ')
          ..write('montantPaye: $montantPaye, ')
          ..write('modePaiement: $modePaiement, ')
          ..write('referencePaiement: $referencePaiement, ')
          ..write('enregistrePar: $enregistrePar, ')
          ..write('datePaiement: $datePaiement, ')
          ..write('dateCreation: $dateCreation')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $ProductUnitsTable productUnits = $ProductUnitsTable(this);
  late final $PriceHistoryTable priceHistory = $PriceHistoryTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final ClientDao clientDao = ClientDao(this as AppDatabase);
  late final ProductDao productDao = ProductDao(this as AppDatabase);
  late final DebtDao debtDao = DebtDao(this as AppDatabase);
  late final PaymentDao paymentDao = PaymentDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        clients,
        products,
        units,
        productUnits,
        priceHistory,
        debts,
        payments
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String nomComplet,
  required String pseudo,
  required String motDePasseHash,
  Value<String> role,
  Value<bool> approuve,
  Value<DateTime> dateCreation,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> nomComplet,
  Value<String> pseudo,
  Value<String> motDePasseHash,
  Value<String> role,
  Value<bool> approuve,
  Value<DateTime> dateCreation,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PriceHistoryTable, List<PriceHistoryData>>
      _priceHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.priceHistory,
          aliasName:
              $_aliasNameGenerator(db.users.id, db.priceHistory.utilisateurId));

  $$PriceHistoryTableProcessedTableManager get priceHistoryRefs {
    final manager = $$PriceHistoryTableTableManager($_db, $_db.priceHistory)
        .filter((f) => f.utilisateurId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_priceHistoryRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DebtsTable, List<Debt>> _debtsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.debts,
          aliasName: $_aliasNameGenerator(db.users.id, db.debts.enregistrePar));

  $$DebtsTableProcessedTableManager get debtsRefs {
    final manager = $$DebtsTableTableManager($_db, $_db.debts)
        .filter((f) => f.enregistrePar.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_debtsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payments,
          aliasName:
              $_aliasNameGenerator(db.users.id, db.payments.enregistrePar));

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager($_db, $_db.payments)
        .filter((f) => f.enregistrePar.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomComplet => $composableBuilder(
      column: $table.nomComplet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pseudo => $composableBuilder(
      column: $table.pseudo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motDePasseHash => $composableBuilder(
      column: $table.motDePasseHash,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get approuve => $composableBuilder(
      column: $table.approuve, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation, builder: (column) => ColumnFilters(column));

  Expression<bool> priceHistoryRefs(
      Expression<bool> Function($$PriceHistoryTableFilterComposer f) f) {
    final $$PriceHistoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.priceHistory,
        getReferencedColumn: (t) => t.utilisateurId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PriceHistoryTableFilterComposer(
              $db: $db,
              $table: $db.priceHistory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> debtsRefs(
      Expression<bool> Function($$DebtsTableFilterComposer f) f) {
    final $$DebtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.enregistrePar,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableFilterComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> paymentsRefs(
      Expression<bool> Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.enregistrePar,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomComplet => $composableBuilder(
      column: $table.nomComplet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pseudo => $composableBuilder(
      column: $table.pseudo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motDePasseHash => $composableBuilder(
      column: $table.motDePasseHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get approuve => $composableBuilder(
      column: $table.approuve, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation,
      builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomComplet => $composableBuilder(
      column: $table.nomComplet, builder: (column) => column);

  GeneratedColumn<String> get pseudo =>
      $composableBuilder(column: $table.pseudo, builder: (column) => column);

  GeneratedColumn<String> get motDePasseHash => $composableBuilder(
      column: $table.motDePasseHash, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get approuve =>
      $composableBuilder(column: $table.approuve, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation, builder: (column) => column);

  Expression<T> priceHistoryRefs<T extends Object>(
      Expression<T> Function($$PriceHistoryTableAnnotationComposer a) f) {
    final $$PriceHistoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.priceHistory,
        getReferencedColumn: (t) => t.utilisateurId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PriceHistoryTableAnnotationComposer(
              $db: $db,
              $table: $db.priceHistory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> debtsRefs<T extends Object>(
      Expression<T> Function($$DebtsTableAnnotationComposer a) f) {
    final $$DebtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.enregistrePar,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableAnnotationComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
      Expression<T> Function($$PaymentsTableAnnotationComposer a) f) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.enregistrePar,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool priceHistoryRefs, bool debtsRefs, bool paymentsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nomComplet = const Value.absent(),
            Value<String> pseudo = const Value.absent(),
            Value<String> motDePasseHash = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<bool> approuve = const Value.absent(),
            Value<DateTime> dateCreation = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            nomComplet: nomComplet,
            pseudo: pseudo,
            motDePasseHash: motDePasseHash,
            role: role,
            approuve: approuve,
            dateCreation: dateCreation,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nomComplet,
            required String pseudo,
            required String motDePasseHash,
            Value<String> role = const Value.absent(),
            Value<bool> approuve = const Value.absent(),
            Value<DateTime> dateCreation = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            nomComplet: nomComplet,
            pseudo: pseudo,
            motDePasseHash: motDePasseHash,
            role: role,
            approuve: approuve,
            dateCreation: dateCreation,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {priceHistoryRefs = false,
              debtsRefs = false,
              paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (priceHistoryRefs) db.priceHistory,
                if (debtsRefs) db.debts,
                if (paymentsRefs) db.payments
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (priceHistoryRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            PriceHistoryData>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._priceHistoryRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .priceHistoryRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.utilisateurId == item.id),
                        typedResults: items),
                  if (debtsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Debt>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._debtsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).debtsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.enregistrePar == item.id),
                        typedResults: items),
                  if (paymentsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Payment>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._paymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).paymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.enregistrePar == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool priceHistoryRefs, bool debtsRefs, bool paymentsRefs})>;
typedef $$ClientsTableCreateCompanionBuilder = ClientsCompanion Function({
  Value<int> id,
  required String nomComplet,
  Value<String> telephone,
  Value<String> adresse,
  Value<String?> cin,
  Value<String?> photoCin,
  Value<String?> photo,
  Value<bool> actif,
  Value<DateTime> dateCreation,
});
typedef $$ClientsTableUpdateCompanionBuilder = ClientsCompanion Function({
  Value<int> id,
  Value<String> nomComplet,
  Value<String> telephone,
  Value<String> adresse,
  Value<String?> cin,
  Value<String?> photoCin,
  Value<String?> photo,
  Value<bool> actif,
  Value<DateTime> dateCreation,
});

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, Client> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DebtsTable, List<Debt>> _debtsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.debts,
          aliasName: $_aliasNameGenerator(db.clients.id, db.debts.clientId));

  $$DebtsTableProcessedTableManager get debtsRefs {
    final manager = $$DebtsTableTableManager($_db, $_db.debts)
        .filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_debtsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomComplet => $composableBuilder(
      column: $table.nomComplet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adresse => $composableBuilder(
      column: $table.adresse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cin => $composableBuilder(
      column: $table.cin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoCin => $composableBuilder(
      column: $table.photoCin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photo => $composableBuilder(
      column: $table.photo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation, builder: (column) => ColumnFilters(column));

  Expression<bool> debtsRefs(
      Expression<bool> Function($$DebtsTableFilterComposer f) f) {
    final $$DebtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableFilterComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomComplet => $composableBuilder(
      column: $table.nomComplet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telephone => $composableBuilder(
      column: $table.telephone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adresse => $composableBuilder(
      column: $table.adresse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cin => $composableBuilder(
      column: $table.cin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoCin => $composableBuilder(
      column: $table.photoCin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photo => $composableBuilder(
      column: $table.photo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation,
      builder: (column) => ColumnOrderings(column));
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomComplet => $composableBuilder(
      column: $table.nomComplet, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get adresse =>
      $composableBuilder(column: $table.adresse, builder: (column) => column);

  GeneratedColumn<String> get cin =>
      $composableBuilder(column: $table.cin, builder: (column) => column);

  GeneratedColumn<String> get photoCin =>
      $composableBuilder(column: $table.photoCin, builder: (column) => column);

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<bool> get actif =>
      $composableBuilder(column: $table.actif, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation, builder: (column) => column);

  Expression<T> debtsRefs<T extends Object>(
      Expression<T> Function($$DebtsTableAnnotationComposer a) f) {
    final $$DebtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableAnnotationComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, $$ClientsTableReferences),
    Client,
    PrefetchHooks Function({bool debtsRefs})> {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nomComplet = const Value.absent(),
            Value<String> telephone = const Value.absent(),
            Value<String> adresse = const Value.absent(),
            Value<String?> cin = const Value.absent(),
            Value<String?> photoCin = const Value.absent(),
            Value<String?> photo = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<DateTime> dateCreation = const Value.absent(),
          }) =>
              ClientsCompanion(
            id: id,
            nomComplet: nomComplet,
            telephone: telephone,
            adresse: adresse,
            cin: cin,
            photoCin: photoCin,
            photo: photo,
            actif: actif,
            dateCreation: dateCreation,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nomComplet,
            Value<String> telephone = const Value.absent(),
            Value<String> adresse = const Value.absent(),
            Value<String?> cin = const Value.absent(),
            Value<String?> photoCin = const Value.absent(),
            Value<String?> photo = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<DateTime> dateCreation = const Value.absent(),
          }) =>
              ClientsCompanion.insert(
            id: id,
            nomComplet: nomComplet,
            telephone: telephone,
            adresse: adresse,
            cin: cin,
            photoCin: photoCin,
            photo: photo,
            actif: actif,
            dateCreation: dateCreation,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ClientsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({debtsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (debtsRefs) db.debts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (debtsRefs)
                    await $_getPrefetchedData<Client, $ClientsTable, Debt>(
                        currentTable: table,
                        referencedTable:
                            $$ClientsTableReferences._debtsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientsTableReferences(db, table, p0).debtsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.clientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, $$ClientsTableReferences),
    Client,
    PrefetchHooks Function({bool debtsRefs})>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String nom,
  Value<String> description,
  Value<bool> actif,
  Value<DateTime> dateCreation,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> nom,
  Value<String> description,
  Value<bool> actif,
  Value<DateTime> dateCreation,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductUnitsTable, List<ProductUnit>>
      _productUnitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.productUnits,
          aliasName:
              $_aliasNameGenerator(db.products.id, db.productUnits.produitId));

  $$ProductUnitsTableProcessedTableManager get productUnitsRefs {
    final manager = $$ProductUnitsTableTableManager($_db, $_db.productUnits)
        .filter((f) => f.produitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productUnitsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation, builder: (column) => ColumnFilters(column));

  Expression<bool> productUnitsRefs(
      Expression<bool> Function($$ProductUnitsTableFilterComposer f) f) {
    final $$ProductUnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.produitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableFilterComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get actif =>
      $composableBuilder(column: $table.actif, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation, builder: (column) => column);

  Expression<T> productUnitsRefs<T extends Object>(
      Expression<T> Function($$ProductUnitsTableAnnotationComposer a) f) {
    final $$ProductUnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.produitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableAnnotationComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function({bool productUnitsRefs})> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<DateTime> dateCreation = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            nom: nom,
            description: description,
            actif: actif,
            dateCreation: dateCreation,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nom,
            Value<String> description = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<DateTime> dateCreation = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            nom: nom,
            description: description,
            actif: actif,
            dateCreation: dateCreation,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({productUnitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productUnitsRefs) db.productUnits],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productUnitsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ProductUnit>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productUnitsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productUnitsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.produitId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function({bool productUnitsRefs})>;
typedef $$UnitsTableCreateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  required String nom,
  Value<String> symbole,
  Value<bool> actif,
});
typedef $$UnitsTableUpdateCompanionBuilder = UnitsCompanion Function({
  Value<int> id,
  Value<String> nom,
  Value<String> symbole,
  Value<bool> actif,
});

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductUnitsTable, List<ProductUnit>>
      _productUnitsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productUnits,
              aliasName:
                  $_aliasNameGenerator(db.units.id, db.productUnits.uniteId));

  $$ProductUnitsTableProcessedTableManager get productUnitsRefs {
    final manager = $$ProductUnitsTableTableManager($_db, $_db.productUnits)
        .filter((f) => f.uniteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productUnitsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbole => $composableBuilder(
      column: $table.symbole, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnFilters(column));

  Expression<bool> productUnitsRefs(
      Expression<bool> Function($$ProductUnitsTableFilterComposer f) f) {
    final $$ProductUnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.uniteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableFilterComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbole => $composableBuilder(
      column: $table.symbole, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnOrderings(column));
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get symbole =>
      $composableBuilder(column: $table.symbole, builder: (column) => column);

  GeneratedColumn<bool> get actif =>
      $composableBuilder(column: $table.actif, builder: (column) => column);

  Expression<T> productUnitsRefs<T extends Object>(
      Expression<T> Function($$ProductUnitsTableAnnotationComposer a) f) {
    final $$ProductUnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.uniteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableAnnotationComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, $$UnitsTableReferences),
    Unit,
    PrefetchHooks Function({bool productUnitsRefs})> {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String> symbole = const Value.absent(),
            Value<bool> actif = const Value.absent(),
          }) =>
              UnitsCompanion(
            id: id,
            nom: nom,
            symbole: symbole,
            actif: actif,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nom,
            Value<String> symbole = const Value.absent(),
            Value<bool> actif = const Value.absent(),
          }) =>
              UnitsCompanion.insert(
            id: id,
            nom: nom,
            symbole: symbole,
            actif: actif,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UnitsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({productUnitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productUnitsRefs) db.productUnits],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productUnitsRefs)
                    await $_getPrefetchedData<Unit, $UnitsTable, ProductUnit>(
                        currentTable: table,
                        referencedTable:
                            $$UnitsTableReferences._productUnitsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UnitsTableReferences(db, table, p0)
                                .productUnitsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.uniteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnitsTable,
    Unit,
    $$UnitsTableFilterComposer,
    $$UnitsTableOrderingComposer,
    $$UnitsTableAnnotationComposer,
    $$UnitsTableCreateCompanionBuilder,
    $$UnitsTableUpdateCompanionBuilder,
    (Unit, $$UnitsTableReferences),
    Unit,
    PrefetchHooks Function({bool productUnitsRefs})>;
typedef $$ProductUnitsTableCreateCompanionBuilder = ProductUnitsCompanion
    Function({
  Value<int> id,
  required int produitId,
  required int uniteId,
  Value<double> prixUnitaire,
  Value<bool> actif,
  Value<DateTime> dateModification,
});
typedef $$ProductUnitsTableUpdateCompanionBuilder = ProductUnitsCompanion
    Function({
  Value<int> id,
  Value<int> produitId,
  Value<int> uniteId,
  Value<double> prixUnitaire,
  Value<bool> actif,
  Value<DateTime> dateModification,
});

final class $$ProductUnitsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductUnitsTable, ProductUnit> {
  $$ProductUnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _produitIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.productUnits.produitId, db.products.id));

  $$ProductsTableProcessedTableManager get produitId {
    final $_column = $_itemColumn<int>('produit_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UnitsTable _uniteIdTable(_$AppDatabase db) => db.units
      .createAlias($_aliasNameGenerator(db.productUnits.uniteId, db.units.id));

  $$UnitsTableProcessedTableManager get uniteId {
    final $_column = $_itemColumn<int>('unite_id')!;

    final manager = $$UnitsTableTableManager($_db, $_db.units)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_uniteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PriceHistoryTable, List<PriceHistoryData>>
      _priceHistoryRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.priceHistory,
              aliasName: $_aliasNameGenerator(
                  db.productUnits.id, db.priceHistory.produitUniteId));

  $$PriceHistoryTableProcessedTableManager get priceHistoryRefs {
    final manager = $$PriceHistoryTableTableManager($_db, $_db.priceHistory)
        .filter((f) => f.produitUniteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_priceHistoryRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DebtsTable, List<Debt>> _debtsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.debts,
          aliasName: $_aliasNameGenerator(
              db.productUnits.id, db.debts.produitUniteId));

  $$DebtsTableProcessedTableManager get debtsRefs {
    final manager = $$DebtsTableTableManager($_db, $_db.debts)
        .filter((f) => f.produitUniteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_debtsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductUnitsTable> {
  $$ProductUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get prixUnitaire => $composableBuilder(
      column: $table.prixUnitaire, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification,
      builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get produitId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.produitId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UnitsTableFilterComposer get uniteId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uniteId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableFilterComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> priceHistoryRefs(
      Expression<bool> Function($$PriceHistoryTableFilterComposer f) f) {
    final $$PriceHistoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.priceHistory,
        getReferencedColumn: (t) => t.produitUniteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PriceHistoryTableFilterComposer(
              $db: $db,
              $table: $db.priceHistory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> debtsRefs(
      Expression<bool> Function($$DebtsTableFilterComposer f) f) {
    final $$DebtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.produitUniteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableFilterComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductUnitsTable> {
  $$ProductUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get prixUnitaire => $composableBuilder(
      column: $table.prixUnitaire,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get actif => $composableBuilder(
      column: $table.actif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification,
      builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get produitId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.produitId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UnitsTableOrderingComposer get uniteId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uniteId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableOrderingComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductUnitsTable> {
  $$ProductUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get prixUnitaire => $composableBuilder(
      column: $table.prixUnitaire, builder: (column) => column);

  GeneratedColumn<bool> get actif =>
      $composableBuilder(column: $table.actif, builder: (column) => column);

  GeneratedColumn<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification, builder: (column) => column);

  $$ProductsTableAnnotationComposer get produitId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.produitId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UnitsTableAnnotationComposer get uniteId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uniteId,
        referencedTable: $db.units,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnitsTableAnnotationComposer(
              $db: $db,
              $table: $db.units,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> priceHistoryRefs<T extends Object>(
      Expression<T> Function($$PriceHistoryTableAnnotationComposer a) f) {
    final $$PriceHistoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.priceHistory,
        getReferencedColumn: (t) => t.produitUniteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PriceHistoryTableAnnotationComposer(
              $db: $db,
              $table: $db.priceHistory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> debtsRefs<T extends Object>(
      Expression<T> Function($$DebtsTableAnnotationComposer a) f) {
    final $$DebtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.produitUniteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableAnnotationComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductUnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductUnitsTable,
    ProductUnit,
    $$ProductUnitsTableFilterComposer,
    $$ProductUnitsTableOrderingComposer,
    $$ProductUnitsTableAnnotationComposer,
    $$ProductUnitsTableCreateCompanionBuilder,
    $$ProductUnitsTableUpdateCompanionBuilder,
    (ProductUnit, $$ProductUnitsTableReferences),
    ProductUnit,
    PrefetchHooks Function(
        {bool produitId,
        bool uniteId,
        bool priceHistoryRefs,
        bool debtsRefs})> {
  $$ProductUnitsTableTableManager(_$AppDatabase db, $ProductUnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> produitId = const Value.absent(),
            Value<int> uniteId = const Value.absent(),
            Value<double> prixUnitaire = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<DateTime> dateModification = const Value.absent(),
          }) =>
              ProductUnitsCompanion(
            id: id,
            produitId: produitId,
            uniteId: uniteId,
            prixUnitaire: prixUnitaire,
            actif: actif,
            dateModification: dateModification,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int produitId,
            required int uniteId,
            Value<double> prixUnitaire = const Value.absent(),
            Value<bool> actif = const Value.absent(),
            Value<DateTime> dateModification = const Value.absent(),
          }) =>
              ProductUnitsCompanion.insert(
            id: id,
            produitId: produitId,
            uniteId: uniteId,
            prixUnitaire: prixUnitaire,
            actif: actif,
            dateModification: dateModification,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductUnitsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {produitId = false,
              uniteId = false,
              priceHistoryRefs = false,
              debtsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (priceHistoryRefs) db.priceHistory,
                if (debtsRefs) db.debts
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (produitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.produitId,
                    referencedTable:
                        $$ProductUnitsTableReferences._produitIdTable(db),
                    referencedColumn:
                        $$ProductUnitsTableReferences._produitIdTable(db).id,
                  ) as T;
                }
                if (uniteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.uniteId,
                    referencedTable:
                        $$ProductUnitsTableReferences._uniteIdTable(db),
                    referencedColumn:
                        $$ProductUnitsTableReferences._uniteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (priceHistoryRefs)
                    await $_getPrefetchedData<ProductUnit, $ProductUnitsTable, PriceHistoryData>(
                        currentTable: table,
                        referencedTable: $$ProductUnitsTableReferences
                            ._priceHistoryRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductUnitsTableReferences(db, table, p0)
                                .priceHistoryRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.produitUniteId == item.id),
                        typedResults: items),
                  if (debtsRefs)
                    await $_getPrefetchedData<ProductUnit, $ProductUnitsTable,
                            Debt>(
                        currentTable: table,
                        referencedTable:
                            $$ProductUnitsTableReferences._debtsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductUnitsTableReferences(db, table, p0)
                                .debtsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.produitUniteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductUnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductUnitsTable,
    ProductUnit,
    $$ProductUnitsTableFilterComposer,
    $$ProductUnitsTableOrderingComposer,
    $$ProductUnitsTableAnnotationComposer,
    $$ProductUnitsTableCreateCompanionBuilder,
    $$ProductUnitsTableUpdateCompanionBuilder,
    (ProductUnit, $$ProductUnitsTableReferences),
    ProductUnit,
    PrefetchHooks Function(
        {bool produitId, bool uniteId, bool priceHistoryRefs, bool debtsRefs})>;
typedef $$PriceHistoryTableCreateCompanionBuilder = PriceHistoryCompanion
    Function({
  Value<int> id,
  required int produitUniteId,
  required double ancienPrix,
  required double nouveauPrix,
  required int utilisateurId,
  Value<DateTime> dateModification,
});
typedef $$PriceHistoryTableUpdateCompanionBuilder = PriceHistoryCompanion
    Function({
  Value<int> id,
  Value<int> produitUniteId,
  Value<double> ancienPrix,
  Value<double> nouveauPrix,
  Value<int> utilisateurId,
  Value<DateTime> dateModification,
});

final class $$PriceHistoryTableReferences extends BaseReferences<_$AppDatabase,
    $PriceHistoryTable, PriceHistoryData> {
  $$PriceHistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductUnitsTable _produitUniteIdTable(_$AppDatabase db) =>
      db.productUnits.createAlias($_aliasNameGenerator(
          db.priceHistory.produitUniteId, db.productUnits.id));

  $$ProductUnitsTableProcessedTableManager get produitUniteId {
    final $_column = $_itemColumn<int>('produit_unite_id')!;

    final manager = $$ProductUnitsTableTableManager($_db, $_db.productUnits)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produitUniteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _utilisateurIdTable(_$AppDatabase db) =>
      db.users.createAlias(
          $_aliasNameGenerator(db.priceHistory.utilisateurId, db.users.id));

  $$UsersTableProcessedTableManager get utilisateurId {
    final $_column = $_itemColumn<int>('utilisateur_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_utilisateurIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PriceHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ancienPrix => $composableBuilder(
      column: $table.ancienPrix, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get nouveauPrix => $composableBuilder(
      column: $table.nouveauPrix, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification,
      builder: (column) => ColumnFilters(column));

  $$ProductUnitsTableFilterComposer get produitUniteId {
    final $$ProductUnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.produitUniteId,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableFilterComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get utilisateurId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utilisateurId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ancienPrix => $composableBuilder(
      column: $table.ancienPrix, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get nouveauPrix => $composableBuilder(
      column: $table.nouveauPrix, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification,
      builder: (column) => ColumnOrderings(column));

  $$ProductUnitsTableOrderingComposer get produitUniteId {
    final $$ProductUnitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.produitUniteId,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableOrderingComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get utilisateurId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utilisateurId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get ancienPrix => $composableBuilder(
      column: $table.ancienPrix, builder: (column) => column);

  GeneratedColumn<double> get nouveauPrix => $composableBuilder(
      column: $table.nouveauPrix, builder: (column) => column);

  GeneratedColumn<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification, builder: (column) => column);

  $$ProductUnitsTableAnnotationComposer get produitUniteId {
    final $$ProductUnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.produitUniteId,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableAnnotationComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get utilisateurId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.utilisateurId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PriceHistoryTable,
    PriceHistoryData,
    $$PriceHistoryTableFilterComposer,
    $$PriceHistoryTableOrderingComposer,
    $$PriceHistoryTableAnnotationComposer,
    $$PriceHistoryTableCreateCompanionBuilder,
    $$PriceHistoryTableUpdateCompanionBuilder,
    (PriceHistoryData, $$PriceHistoryTableReferences),
    PriceHistoryData,
    PrefetchHooks Function({bool produitUniteId, bool utilisateurId})> {
  $$PriceHistoryTableTableManager(_$AppDatabase db, $PriceHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> produitUniteId = const Value.absent(),
            Value<double> ancienPrix = const Value.absent(),
            Value<double> nouveauPrix = const Value.absent(),
            Value<int> utilisateurId = const Value.absent(),
            Value<DateTime> dateModification = const Value.absent(),
          }) =>
              PriceHistoryCompanion(
            id: id,
            produitUniteId: produitUniteId,
            ancienPrix: ancienPrix,
            nouveauPrix: nouveauPrix,
            utilisateurId: utilisateurId,
            dateModification: dateModification,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int produitUniteId,
            required double ancienPrix,
            required double nouveauPrix,
            required int utilisateurId,
            Value<DateTime> dateModification = const Value.absent(),
          }) =>
              PriceHistoryCompanion.insert(
            id: id,
            produitUniteId: produitUniteId,
            ancienPrix: ancienPrix,
            nouveauPrix: nouveauPrix,
            utilisateurId: utilisateurId,
            dateModification: dateModification,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PriceHistoryTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {produitUniteId = false, utilisateurId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (produitUniteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.produitUniteId,
                    referencedTable:
                        $$PriceHistoryTableReferences._produitUniteIdTable(db),
                    referencedColumn: $$PriceHistoryTableReferences
                        ._produitUniteIdTable(db)
                        .id,
                  ) as T;
                }
                if (utilisateurId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.utilisateurId,
                    referencedTable:
                        $$PriceHistoryTableReferences._utilisateurIdTable(db),
                    referencedColumn: $$PriceHistoryTableReferences
                        ._utilisateurIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PriceHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PriceHistoryTable,
    PriceHistoryData,
    $$PriceHistoryTableFilterComposer,
    $$PriceHistoryTableOrderingComposer,
    $$PriceHistoryTableAnnotationComposer,
    $$PriceHistoryTableCreateCompanionBuilder,
    $$PriceHistoryTableUpdateCompanionBuilder,
    (PriceHistoryData, $$PriceHistoryTableReferences),
    PriceHistoryData,
    PrefetchHooks Function({bool produitUniteId, bool utilisateurId})>;
typedef $$DebtsTableCreateCompanionBuilder = DebtsCompanion Function({
  Value<int> id,
  required String numeroFacture,
  required int clientId,
  required int produitUniteId,
  required double quantite,
  required double prixUnitaireFige,
  required double montantTotal,
  Value<double> montantPaye,
  required double montantRestant,
  Value<String> statut,
  required int enregistrePar,
  required DateTime dateDette,
  Value<DateTime> dateModification,
});
typedef $$DebtsTableUpdateCompanionBuilder = DebtsCompanion Function({
  Value<int> id,
  Value<String> numeroFacture,
  Value<int> clientId,
  Value<int> produitUniteId,
  Value<double> quantite,
  Value<double> prixUnitaireFige,
  Value<double> montantTotal,
  Value<double> montantPaye,
  Value<double> montantRestant,
  Value<String> statut,
  Value<int> enregistrePar,
  Value<DateTime> dateDette,
  Value<DateTime> dateModification,
});

final class $$DebtsTableReferences
    extends BaseReferences<_$AppDatabase, $DebtsTable, Debt> {
  $$DebtsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) => db.clients
      .createAlias($_aliasNameGenerator(db.debts.clientId, db.clients.id));

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager($_db, $_db.clients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductUnitsTable _produitUniteIdTable(_$AppDatabase db) =>
      db.productUnits.createAlias(
          $_aliasNameGenerator(db.debts.produitUniteId, db.productUnits.id));

  $$ProductUnitsTableProcessedTableManager get produitUniteId {
    final $_column = $_itemColumn<int>('produit_unite_id')!;

    final manager = $$ProductUnitsTableTableManager($_db, $_db.productUnits)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produitUniteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _enregistreParTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.debts.enregistrePar, db.users.id));

  $$UsersTableProcessedTableManager get enregistrePar {
    final $_column = $_itemColumn<int>('enregistre_par')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enregistreParTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payments,
          aliasName: $_aliasNameGenerator(db.debts.id, db.payments.detteId));

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager($_db, $_db.payments)
        .filter((f) => f.detteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DebtsTableFilterComposer extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numeroFacture => $composableBuilder(
      column: $table.numeroFacture, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantite => $composableBuilder(
      column: $table.quantite, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get prixUnitaireFige => $composableBuilder(
      column: $table.prixUnitaireFige,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantTotal => $composableBuilder(
      column: $table.montantTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantPaye => $composableBuilder(
      column: $table.montantPaye, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantRestant => $composableBuilder(
      column: $table.montantRestant,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateDette => $composableBuilder(
      column: $table.dateDette, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification,
      builder: (column) => ColumnFilters(column));

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableFilterComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductUnitsTableFilterComposer get produitUniteId {
    final $$ProductUnitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.produitUniteId,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableFilterComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get enregistrePar {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.enregistrePar,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> paymentsRefs(
      Expression<bool> Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.detteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numeroFacture => $composableBuilder(
      column: $table.numeroFacture,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantite => $composableBuilder(
      column: $table.quantite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get prixUnitaireFige => $composableBuilder(
      column: $table.prixUnitaireFige,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantTotal => $composableBuilder(
      column: $table.montantTotal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantPaye => $composableBuilder(
      column: $table.montantPaye, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantRestant => $composableBuilder(
      column: $table.montantRestant,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateDette => $composableBuilder(
      column: $table.dateDette, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification,
      builder: (column) => ColumnOrderings(column));

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableOrderingComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductUnitsTableOrderingComposer get produitUniteId {
    final $$ProductUnitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.produitUniteId,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableOrderingComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get enregistrePar {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.enregistrePar,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get numeroFacture => $composableBuilder(
      column: $table.numeroFacture, builder: (column) => column);

  GeneratedColumn<double> get quantite =>
      $composableBuilder(column: $table.quantite, builder: (column) => column);

  GeneratedColumn<double> get prixUnitaireFige => $composableBuilder(
      column: $table.prixUnitaireFige, builder: (column) => column);

  GeneratedColumn<double> get montantTotal => $composableBuilder(
      column: $table.montantTotal, builder: (column) => column);

  GeneratedColumn<double> get montantPaye => $composableBuilder(
      column: $table.montantPaye, builder: (column) => column);

  GeneratedColumn<double> get montantRestant => $composableBuilder(
      column: $table.montantRestant, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<DateTime> get dateDette =>
      $composableBuilder(column: $table.dateDette, builder: (column) => column);

  GeneratedColumn<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsTableAnnotationComposer(
              $db: $db,
              $table: $db.clients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductUnitsTableAnnotationComposer get produitUniteId {
    final $$ProductUnitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.produitUniteId,
        referencedTable: $db.productUnits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductUnitsTableAnnotationComposer(
              $db: $db,
              $table: $db.productUnits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get enregistrePar {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.enregistrePar,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> paymentsRefs<T extends Object>(
      Expression<T> Function($$PaymentsTableAnnotationComposer a) f) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.detteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DebtsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableAnnotationComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, $$DebtsTableReferences),
    Debt,
    PrefetchHooks Function(
        {bool clientId,
        bool produitUniteId,
        bool enregistrePar,
        bool paymentsRefs})> {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> numeroFacture = const Value.absent(),
            Value<int> clientId = const Value.absent(),
            Value<int> produitUniteId = const Value.absent(),
            Value<double> quantite = const Value.absent(),
            Value<double> prixUnitaireFige = const Value.absent(),
            Value<double> montantTotal = const Value.absent(),
            Value<double> montantPaye = const Value.absent(),
            Value<double> montantRestant = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<int> enregistrePar = const Value.absent(),
            Value<DateTime> dateDette = const Value.absent(),
            Value<DateTime> dateModification = const Value.absent(),
          }) =>
              DebtsCompanion(
            id: id,
            numeroFacture: numeroFacture,
            clientId: clientId,
            produitUniteId: produitUniteId,
            quantite: quantite,
            prixUnitaireFige: prixUnitaireFige,
            montantTotal: montantTotal,
            montantPaye: montantPaye,
            montantRestant: montantRestant,
            statut: statut,
            enregistrePar: enregistrePar,
            dateDette: dateDette,
            dateModification: dateModification,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String numeroFacture,
            required int clientId,
            required int produitUniteId,
            required double quantite,
            required double prixUnitaireFige,
            required double montantTotal,
            Value<double> montantPaye = const Value.absent(),
            required double montantRestant,
            Value<String> statut = const Value.absent(),
            required int enregistrePar,
            required DateTime dateDette,
            Value<DateTime> dateModification = const Value.absent(),
          }) =>
              DebtsCompanion.insert(
            id: id,
            numeroFacture: numeroFacture,
            clientId: clientId,
            produitUniteId: produitUniteId,
            quantite: quantite,
            prixUnitaireFige: prixUnitaireFige,
            montantTotal: montantTotal,
            montantPaye: montantPaye,
            montantRestant: montantRestant,
            statut: statut,
            enregistrePar: enregistrePar,
            dateDette: dateDette,
            dateModification: dateModification,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DebtsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {clientId = false,
              produitUniteId = false,
              enregistrePar = false,
              paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (paymentsRefs) db.payments],
              addJoins: <
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
                      dynamic>>(state) {
                if (clientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clientId,
                    referencedTable: $$DebtsTableReferences._clientIdTable(db),
                    referencedColumn:
                        $$DebtsTableReferences._clientIdTable(db).id,
                  ) as T;
                }
                if (produitUniteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.produitUniteId,
                    referencedTable:
                        $$DebtsTableReferences._produitUniteIdTable(db),
                    referencedColumn:
                        $$DebtsTableReferences._produitUniteIdTable(db).id,
                  ) as T;
                }
                if (enregistrePar) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.enregistrePar,
                    referencedTable:
                        $$DebtsTableReferences._enregistreParTable(db),
                    referencedColumn:
                        $$DebtsTableReferences._enregistreParTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentsRefs)
                    await $_getPrefetchedData<Debt, $DebtsTable, Payment>(
                        currentTable: table,
                        referencedTable:
                            $$DebtsTableReferences._paymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtsTableReferences(db, table, p0).paymentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.detteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DebtsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableAnnotationComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, $$DebtsTableReferences),
    Debt,
    PrefetchHooks Function(
        {bool clientId,
        bool produitUniteId,
        bool enregistrePar,
        bool paymentsRefs})>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  required int detteId,
  required double montantPaye,
  Value<String> modePaiement,
  Value<String> referencePaiement,
  required int enregistrePar,
  required DateTime datePaiement,
  Value<DateTime> dateCreation,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<int> detteId,
  Value<double> montantPaye,
  Value<String> modePaiement,
  Value<String> referencePaiement,
  Value<int> enregistrePar,
  Value<DateTime> datePaiement,
  Value<DateTime> dateCreation,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DebtsTable _detteIdTable(_$AppDatabase db) => db.debts
      .createAlias($_aliasNameGenerator(db.payments.detteId, db.debts.id));

  $$DebtsTableProcessedTableManager get detteId {
    final $_column = $_itemColumn<int>('dette_id')!;

    final manager = $$DebtsTableTableManager($_db, $_db.debts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_detteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _enregistreParTable(_$AppDatabase db) =>
      db.users.createAlias(
          $_aliasNameGenerator(db.payments.enregistrePar, db.users.id));

  $$UsersTableProcessedTableManager get enregistrePar {
    final $_column = $_itemColumn<int>('enregistre_par')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enregistreParTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montantPaye => $composableBuilder(
      column: $table.montantPaye, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modePaiement => $composableBuilder(
      column: $table.modePaiement, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referencePaiement => $composableBuilder(
      column: $table.referencePaiement,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation, builder: (column) => ColumnFilters(column));

  $$DebtsTableFilterComposer get detteId {
    final $$DebtsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.detteId,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableFilterComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get enregistrePar {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.enregistrePar,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montantPaye => $composableBuilder(
      column: $table.montantPaye, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modePaiement => $composableBuilder(
      column: $table.modePaiement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referencePaiement => $composableBuilder(
      column: $table.referencePaiement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation,
      builder: (column) => ColumnOrderings(column));

  $$DebtsTableOrderingComposer get detteId {
    final $$DebtsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.detteId,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableOrderingComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get enregistrePar {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.enregistrePar,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get montantPaye => $composableBuilder(
      column: $table.montantPaye, builder: (column) => column);

  GeneratedColumn<String> get modePaiement => $composableBuilder(
      column: $table.modePaiement, builder: (column) => column);

  GeneratedColumn<String> get referencePaiement => $composableBuilder(
      column: $table.referencePaiement, builder: (column) => column);

  GeneratedColumn<DateTime> get datePaiement => $composableBuilder(
      column: $table.datePaiement, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCreation => $composableBuilder(
      column: $table.dateCreation, builder: (column) => column);

  $$DebtsTableAnnotationComposer get detteId {
    final $$DebtsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.detteId,
        referencedTable: $db.debts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtsTableAnnotationComposer(
              $db: $db,
              $table: $db.debts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get enregistrePar {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.enregistrePar,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool detteId, bool enregistrePar})> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> detteId = const Value.absent(),
            Value<double> montantPaye = const Value.absent(),
            Value<String> modePaiement = const Value.absent(),
            Value<String> referencePaiement = const Value.absent(),
            Value<int> enregistrePar = const Value.absent(),
            Value<DateTime> datePaiement = const Value.absent(),
            Value<DateTime> dateCreation = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            detteId: detteId,
            montantPaye: montantPaye,
            modePaiement: modePaiement,
            referencePaiement: referencePaiement,
            enregistrePar: enregistrePar,
            datePaiement: datePaiement,
            dateCreation: dateCreation,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int detteId,
            required double montantPaye,
            Value<String> modePaiement = const Value.absent(),
            Value<String> referencePaiement = const Value.absent(),
            required int enregistrePar,
            required DateTime datePaiement,
            Value<DateTime> dateCreation = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            detteId: detteId,
            montantPaye: montantPaye,
            modePaiement: modePaiement,
            referencePaiement: referencePaiement,
            enregistrePar: enregistrePar,
            datePaiement: datePaiement,
            dateCreation: dateCreation,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PaymentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({detteId = false, enregistrePar = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (detteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.detteId,
                    referencedTable:
                        $$PaymentsTableReferences._detteIdTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._detteIdTable(db).id,
                  ) as T;
                }
                if (enregistrePar) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.enregistrePar,
                    referencedTable:
                        $$PaymentsTableReferences._enregistreParTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._enregistreParTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool detteId, bool enregistrePar})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$ProductUnitsTableTableManager get productUnits =>
      $$ProductUnitsTableTableManager(_db, _db.productUnits);
  $$PriceHistoryTableTableManager get priceHistory =>
      $$PriceHistoryTableTableManager(_db, _db.priceHistory);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
}
