import 'package:equatable/equatable.dart';

class ClientModel extends Equatable {
  final int id;
  final String nomComplet;
  final String telephone;
  final String adresse;
  final String? cin;
  final String? photoCin;
  final String? photo;
  final bool actif;
  final DateTime dateCreation;

  const ClientModel({
    required this.id,
    required this.nomComplet,
    required this.telephone,
    required this.adresse,
    this.cin,
    this.photoCin,
    this.photo,
    required this.actif,
    required this.dateCreation,
  });

  String get initiale =>
      nomComplet.isNotEmpty ? nomComplet[0].toUpperCase() : '?';

  String get prenomAffichage {
    final parts = nomComplet.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : nomComplet;
  }

  bool get estVerifie =>
      cin != null &&
          cin!.length == 12 &&
          photoCin != null &&
          photoCin!.isNotEmpty;

  ClientModel copyWith({
    int? id,
    String? nomComplet,
    String? telephone,
    String? adresse,
    String? cin,
    String? photoCin,
    String? photo,
    bool? actif,
    DateTime? dateCreation,
  }) {
    return ClientModel(
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
  List<Object?> get props =>
      [id, nomComplet, telephone, cin, actif];

  @override
  String toString() =>
      'ClientModel(id: $id, nom: $nomComplet, cin: $cin, verifie: $estVerifie)';
}