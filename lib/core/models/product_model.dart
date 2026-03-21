import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String nom;
  final String description;
  final bool actif;
  final DateTime dateCreation;

  const ProductModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.actif,
    required this.dateCreation,
  });

  ProductModel copyWith({
    int? id,
    String? nom,
    String? description,
    bool? actif,
    DateTime? dateCreation,
  }) {
    return ProductModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      actif: actif ?? this.actif,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'actif': actif ? 1 : 0,
      'date_creation': dateCreation.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      nom: map['nom'] as String,
      description: map['description'] as String? ?? '',
      actif: (map['actif'] as int? ?? 1) == 1,
      dateCreation: DateTime.parse(map['date_creation'] as String),
    );
  }

  @override
  List<Object?> get props => [id, nom, actif];

  @override
  String toString() => 'ProductModel(id: $id, nom: $nom)';
}