import 'package:equatable/equatable.dart';

class ProductUnitModel extends Equatable {
  final int id;
  final int produitId;
  final int uniteId;
  final double prixUnitaire;
  final bool actif;
  final DateTime dateModification;

  // Champs joints (optionnels - remplis par les requetes avec JOIN)
  final String? nomProduit;
  final String? nomUnite;
  final String? symbolesUnite;

  const ProductUnitModel({
    required this.id,
    required this.produitId,
    required this.uniteId,
    required this.prixUnitaire,
    required this.actif,
    required this.dateModification,
    this.nomProduit,
    this.nomUnite,
    this.symbolesUnite,
  });

  String get labelUnite => symbolesUnite?.isNotEmpty == true ? symbolesUnite! : (nomUnite ?? '');

  String get labelComplet => nomProduit != null ? '$nomProduit - $labelUnite' : labelUnite;

  ProductUnitModel copyWith({
    int? id,
    int? produitId,
    int? uniteId,
    double? prixUnitaire,
    bool? actif,
    DateTime? dateModification,
    String? nomProduit,
    String? nomUnite,
    String? symbolesUnite,
  }) {
    return ProductUnitModel(
      id: id ?? this.id,
      produitId: produitId ?? this.produitId,
      uniteId: uniteId ?? this.uniteId,
      prixUnitaire: prixUnitaire ?? this.prixUnitaire,
      actif: actif ?? this.actif,
      dateModification: dateModification ?? this.dateModification,
      nomProduit: nomProduit ?? this.nomProduit,
      nomUnite: nomUnite ?? this.nomUnite,
      symbolesUnite: symbolesUnite ?? this.symbolesUnite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produit_id': produitId,
      'unite_id': uniteId,
      'prix_unitaire': prixUnitaire,
      'actif': actif ? 1 : 0,
      'date_modification': dateModification.toIso8601String(),
    };
  }

  factory ProductUnitModel.fromMap(Map<String, dynamic> map) {
    return ProductUnitModel(
      id: map['id'] as int,
      produitId: map['produit_id'] as int,
      uniteId: map['unite_id'] as int,
      prixUnitaire: (map['prix_unitaire'] as num).toDouble(),
      actif: (map['actif'] as int? ?? 1) == 1,
      dateModification: DateTime.parse(map['date_modification'] as String),
      nomProduit: map['nom_produit'] as String?,
      nomUnite: map['nom_unite'] as String?,
      symbolesUnite: map['symbole_unite'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, produitId, uniteId, prixUnitaire];

  @override
  String toString() =>
      'ProductUnitModel(id: $id, produit: $produitId, unite: $uniteId, prix: $prixUnitaire)';
}