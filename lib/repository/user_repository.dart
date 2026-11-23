import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillo/models/user_model.dart';

class UserRepository {
  final CollectionReference _user = FirebaseFirestore.instance.collection(
    'User',
  );

  Future<void> getUser(String nom, String email) async {
    final user = await _user
        .where('nom', isEqualTo: nom)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    final utilisateur = User.fromFirestore(user.docs.first);

    if (utilisateur.email.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isConnect', true);
      await prefs.setString('id', utilisateur.id);
      await prefs.setString('nom', utilisateur.nom);
      await prefs.setString('prenom', utilisateur.prenom);
      await prefs.setString('mail', utilisateur.email);
      await prefs.setString('age', utilisateur.age);
      await prefs.setString('motivation', utilisateur.motivation);
    }
  }

  Future<void> addUser(
    String nom,
    String prenom,
    String email,
    String age,
    String adressePostal,
    String motivation,
  ) async {
    await _user.add({
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'age': age,
      'adressePostal': adressePostal,
      'motivation': motivation,
    });
  }

  Future<void> updateUser(
    String id,
    String nom,
    String prenom,
    String email,
    String age,
    String adressePostal,
    String motivation,
  ) async {
    await _user.doc(id).update({
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'age': age,
      'adressePostal': adressePostal,
      'motivation': motivation,
    });
  }

  Future<void> deleteQuestion(String id) async {
    await _user.doc(id).delete();
  }
}
