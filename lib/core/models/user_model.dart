import 'package:equatable/equatable.dart';

enum UserRole { superuser, admin, utilisateur }

class UserModel extends Equatable {
  final int id;
  final String nomComplet;
  final String pseudo;
  final String motDePasseHash;
  final UserRole role;
  final bool approuve;
  final DateTime dateCreation;

  const UserModel({
    required this.id,
    required this.nomComplet,
    required this.pseudo,
    required this.motDePasseHash,
    required this.role,
    required this.approuve,
    required this.dateCreation,
  });

  String get initiale =>
      nomComplet.isNotEmpty ? nomComplet[0].toUpperCase() : '?';

  String get prenomAffichage {
    final parts = nomComplet.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : nomComplet;
  }

  bool get estSuperuser => role == UserRole.superuser;
  bool get estAdmin => role == UserRole.admin || role == UserRole.superuser;
  bool get estUtilisateur => role == UserRole.utilisateur;
  bool get peutSeConnecter => approuve;

  String get roleLabel {
    switch (role) {
      case UserRole.superuser:
        return 'Superutilisateur';
      case UserRole.admin:
        return 'Administrateur';
      case UserRole.utilisateur:
        return 'Utilisateur';
    }
  }

  static UserRole roleFromString(String r) {
    switch (r) {
      case 'superuser':
        return UserRole.superuser;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.utilisateur;
    }
  }

  static String roleToString(UserRole r) {
    switch (r) {
      case UserRole.superuser:
        return 'superuser';
      case UserRole.admin:
        return 'admin';
      case UserRole.utilisateur:
        return 'utilisateur';
    }
  }

  UserModel copyWith({
    int? id,
    String? nomComplet,
    String? pseudo,
    String? motDePasseHash,
    UserRole? role,
    bool? approuve,
    DateTime? dateCreation,
  }) {
    return UserModel(
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
  List<Object?> get props => [id, pseudo, role, approuve];

  @override
  String toString() =>
      'UserModel(id: $id, pseudo: $pseudo, role: $role, approuve: $approuve)';
}