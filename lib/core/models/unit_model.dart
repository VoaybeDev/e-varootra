import 'package:equatable/equatable.dart';

class UnitModel extends Equatable {
  final int id;
  final String nom;
  final String symbole;
  final bool actif;

  const UnitModel({
    required this.id,
    required this.nom,
    required this.symbole,
    required this.actif,
  });

  String get affichage => symbole.isNotEmpty ? symbole : nom;

  UnitModel copyWith({
    int? id,
    String? nom,
    String? symbole,
    bool? actif,
  }) {
    return UnitModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      symbole: symbole ?? this.symbole,
      actif: actif ?? this.actif,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'symbole': symbole,
      'actif': actif ? 1 : 0,
    };
  }

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    return UnitModel(
      id: map['id'] as int,
      nom: map['nom'] as String,
      symbole: map['symbole'] as String? ?? '',
      actif: (map['actif'] as int? ?? 1) == 1,
    );
  }

  @override
  List<Object?> get props => [id, nom, symbole];

  @override
  String toString() => 'UnitModel(id: $id, nom: $nom, symbole: $symbole)';
}