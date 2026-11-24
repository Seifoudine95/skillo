import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String age;
  final String adressePostal;
  final String motivation;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.age,
    required this.adressePostal,
    required this.motivation,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? data['prénom'] ?? '',
      email: data['email'] ?? data['e-mail'] ?? '',
      age: '${data['age'] ?? data['âge'] ?? ''}',
      adressePostal: data['adressePostal'] ?? data['adresse postale'] ?? '',
      motivation: data['motivation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'age': age,
      'adressePostal': adressePostal,
      'motivation': motivation,
    };
  }
}
