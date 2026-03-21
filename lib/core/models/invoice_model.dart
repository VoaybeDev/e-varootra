import 'package:equatable/equatable.dart';

import '../../app/utils/constants.dart';
import 'debt_line_model.dart';
import 'payment_model.dart';

class InvoiceModel extends Equatable {
  final String numeroFacture;
  final int clientId;
  final String nomClient;
  final String telephoneClient;
  final DateTime dateDette;
  final List<DebtLineModel> lignes;
  final List<PaymentModel> paiements;
  final int enregistrePar;
  final String nomVendeur;

  const InvoiceModel({
    required this.numeroFacture,
    required this.clientId,
    required this.nomClient,
    required this.telephoneClient,
    required this.dateDette,
    required this.lignes,
    required this.paiements,
    required this.enregistrePar,
    required this.nomVendeur,
  });

  // Montant total de la facture
  double get montantTotal => lignes.fold(0.0, (sum, l) => sum + l.montantTotal);

  // Montant total paye sur la facture
  double get montantPaye => lignes.fold(0.0, (sum, l) => sum + l.montantPaye);

  // Montant restant
  double get montantRestant => lignes.fold(0.0, (sum, l) => sum + l.montantRestant);

  // Statut global de la facture
  String get statut {
    if (montantRestant <= 0) return AppConstants.statusPaid;
    if (montantPaye > 0) return AppConstants.statusPartial;
    return AppConstants.statusActive;
  }

  bool get estPayee => statut == AppConstants.statusPaid;
  bool get estPartielle => statut == AppConstants.statusPartial;
  bool get estActive => statut == AppConstants.statusActive;

  // Description courte des produits
  String get descriptionProduits {
    return lignes.map((l) => l.descriptionProduit).join(', ');
  }

  // Nombre de lignes
  int get nombreLignes => lignes.length;

  @override
  List<Object?> get props => [numeroFacture, clientId, dateDette];

  @override
  String toString() =>
      'InvoiceModel(num: $numeroFacture, client: $nomClient, total: $montantTotal, statut: $statut)';
}