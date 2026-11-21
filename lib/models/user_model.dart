import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final int? age;
  final String adressePostal;
  final String motivation;

  User({
    required this.id,
    required this.nom,
    required this.email,
    required this.prenom,
    required this.age,
    required this.adressePostal,
    required this.motivation,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      age: data['age'],
      adressePostal: data['adressePostal'] ?? '',
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
