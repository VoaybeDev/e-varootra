import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String nomComplet;
  final String pseudo;
  final String motDePasseHash;
  final DateTime dateCreation;

  const UserModel({
    required this.id,
    required this.nomComplet,
    required this.pseudo,
    required this.motDePasseHash,
    required this.dateCreation,
  });

  String get initiale => nomComplet.isNotEmpty ? nomComplet[0].toUpperCase() : '?';

  String get prenomAffichage {
    final parts = nomComplet.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : nomComplet;
  }

  UserModel copyWith({
    int? id,
    String? nomComplet,
    String? pseudo,
    String? motDePasseHash,
    DateTime? dateCreation,
  }) {
    return UserModel(
      id: id ?? this.id,
      nomComplet: nomComplet ?? this.nomComplet,
      pseudo: pseudo ?? this.pseudo,
      motDePasseHash: motDePasseHash ?? this.motDePasseHash,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom_complet': nomComplet,
      'pseudo': pseudo,
      'mot_de_passe_hash': motDePasseHash,
      'date_creation': dateCreation.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      nomComplet: map['nom_complet'] as String,
      pseudo: map['pseudo'] as String,
      motDePasseHash: map['mot_de_passe_hash'] as String,
      dateCreation: DateTime.parse(map['date_creation'] as String),
    );
  }

  @override
  List<Object?> get props => [id, pseudo];

  @override
  String toString() => 'UserModel(id: $id, pseudo: $pseudo, nom: $nomComplet)';
}