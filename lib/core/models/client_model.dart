import 'package:equatable/equatable.dart';

class ClientModel extends Equatable {
  final int id;
  final String nomComplet;
  final String telephone;
  final String adresse;
  final bool actif;
  final DateTime dateCreation;

  const ClientModel({
    required this.id,
    required this.nomComplet,
    required this.telephone,
    required this.adresse,
    required this.actif,
    required this.dateCreation,
  });

  String get initiale => nomComplet.isNotEmpty ? nomComplet[0].toUpperCase() : '?';

  String get prenomAffichage {
    final parts = nomComplet.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : nomComplet;
  }

  ClientModel copyWith({
    int? id,
    String? nomComplet,
    String? telephone,
    String? adresse,
    bool? actif,
    DateTime? dateCreation,
  }) {
    return ClientModel(
      id: id ?? this.id,
      nomComplet: nomComplet ?? this.nomComplet,
      telephone: telephone ?? this.telephone,
      adresse: adresse ?? this.adresse,
      actif: actif ?? this.actif,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom_complet': nomComplet,
      'telephone': telephone,
      'adresse': adresse,
      'actif': actif ? 1 : 0,
      'date_creation': dateCreation.toIso8601String(),
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] as int,
      nomComplet: map['nom_complet'] as String,
      telephone: map['telephone'] as String? ?? '',
      adresse: map['adresse'] as String? ?? '',
      actif: (map['actif'] as int? ?? 1) == 1,
      dateCreation: DateTime.parse(map['date_creation'] as String),
    );
  }

  @override
  List<Object?> get props => [id, nomComplet, telephone, actif];

  @override
  String toString() => 'ClientModel(id: $id, nom: $nomComplet, actif: $actif)';
}