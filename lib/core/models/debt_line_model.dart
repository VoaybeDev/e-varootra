import 'package:equatable/equatable.dart';

import '../../app/utils/constants.dart';

class DebtLineModel extends Equatable {
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

  // Champs joints
  final String? nomClient;
  final String? nomProduit;
  final String? nomUnite;

  const DebtLineModel({
    required this.id,
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
    required this.dateModification,
    this.nomClient,
    this.nomProduit,
    this.nomUnite,
  });

  bool get estActive => statut == AppConstants.statusActive;
  bool get estPartielle => statut == AppConstants.statusPartial;
  bool get estPayee => statut == AppConstants.statusPaid;

  String get descriptionProduit {
    if (nomProduit != null && nomUnite != null) {
      return '$nomProduit ($nomUnite)';
    }
    return nomProduit ?? 'Produit inconnu';
  }

  DebtLineModel copyWith({
    int? id,
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
    DateTime? dateModification,
    String? nomClient,
    String? nomProduit,
    String? nomUnite,
  }) {
    return DebtLineModel(
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
      nomClient: nomClient ?? this.nomClient,
      nomProduit: nomProduit ?? this.nomProduit,
      nomUnite: nomUnite ?? this.nomUnite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero_facture': numeroFacture,
      'client_id': clientId,
      'produit_unite_id': produitUniteId,
      'quantite': quantite,
      'prix_unitaire_fige': prixUnitaireFige,
      'montant_total': montantTotal,
      'montant_paye': montantPaye,
      'montant_restant': montantRestant,
      'statut': statut,
      'enregistre_par': enregistrePar,
      'date_dette': dateDette.toIso8601String(),
      'date_modification': dateModification.toIso8601String(),
    };
  }

  factory DebtLineModel.fromMap(Map<String, dynamic> map) {
    return DebtLineModel(
      id: map['id'] as int,
      numeroFacture: map['numero_facture'] as String,
      clientId: map['client_id'] as int,
      produitUniteId: map['produit_unite_id'] as int,
      quantite: (map['quantite'] as num).toDouble(),
      prixUnitaireFige: (map['prix_unitaire_fige'] as num).toDouble(),
      montantTotal: (map['montant_total'] as num).toDouble(),
      montantPaye: (map['montant_paye'] as num).toDouble(),
      montantRestant: (map['montant_restant'] as num).toDouble(),
      statut: map['statut'] as String,
      enregistrePar: map['enregistre_par'] as int,
      dateDette: DateTime.parse(map['date_dette'] as String),
      dateModification: DateTime.parse(map['date_modification'] as String),
      nomClient: map['nom_client'] as String?,
      nomProduit: map['nom_produit'] as String?,
      nomUnite: map['nom_unite'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, numeroFacture, produitUniteId];

  @override
  String toString() =>
      'DebtLineModel(id: $id, facture: $numeroFacture, statut: $statut)';
}