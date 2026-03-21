import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final int id;
  final int detteId;
  final double montantPaye;
  final String modePaiement;
  final String referencePaiement;
  final int enregistrePar;
  final DateTime datePaiement;
  final DateTime dateCreation;

  // Champs joints
  final String? nomUtilisateur;
  final String? numeroFacture;

  const PaymentModel({
    required this.id,
    required this.detteId,
    required this.montantPaye,
    required this.modePaiement,
    required this.referencePaiement,
    required this.enregistrePar,
    required this.datePaiement,
    required this.dateCreation,
    this.nomUtilisateur,
    this.numeroFacture,
  });

  PaymentModel copyWith({
    int? id,
    int? detteId,
    double? montantPaye,
    String? modePaiement,
    String? referencePaiement,
    int? enregistrePar,
    DateTime? datePaiement,
    DateTime? dateCreation,
    String? nomUtilisateur,
    String? numeroFacture,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      detteId: detteId ?? this.detteId,
      montantPaye: montantPaye ?? this.montantPaye,
      modePaiement: modePaiement ?? this.modePaiement,
      referencePaiement: referencePaiement ?? this.referencePaiement,
      enregistrePar: enregistrePar ?? this.enregistrePar,
      datePaiement: datePaiement ?? this.datePaiement,
      dateCreation: dateCreation ?? this.dateCreation,
      nomUtilisateur: nomUtilisateur ?? this.nomUtilisateur,
      numeroFacture: numeroFacture ?? this.numeroFacture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dette_id': detteId,
      'montant_paye': montantPaye,
      'mode_paiement': modePaiement,
      'reference_paiement': referencePaiement,
      'enregistre_par': enregistrePar,
      'date_paiement': datePaiement.toIso8601String(),
      'date_creation': dateCreation.toIso8601String(),
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] as int,
      detteId: map['dette_id'] as int,
      montantPaye: (map['montant_paye'] as num).toDouble(),
      modePaiement: map['mode_paiement'] as String? ?? 'Especes',
      referencePaiement: map['reference_paiement'] as String? ?? '',
      enregistrePar: map['enregistre_par'] as int,
      datePaiement: DateTime.parse(map['date_paiement'] as String),
      dateCreation: DateTime.parse(map['date_creation'] as String),
      nomUtilisateur: map['nom_utilisateur'] as String?,
      numeroFacture: map['numero_facture'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, detteId, montantPaye, referencePaiement];

  @override
  String toString() =>
      'PaymentModel(id: $id, dette: $detteId, montant: $montantPaye)';
}