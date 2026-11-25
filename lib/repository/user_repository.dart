import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:skillo/models/resultat_model.dart';
import 'package:skillo/models/user_model.dart';

class UserRepository extends ChangeNotifier {
  final CollectionReference _user = FirebaseFirestore.instance.collection(
    'User',
  );

  User? utilisateurCourant;
  bool isConnect = false;
  List<Resultat>? resultats;

  Future<void> connexionUser(String nom, String email) async {
    final user = await _user
        .where('nom', isEqualTo: nom)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (user.docs.isNotEmpty) {
      final utilisateur = User.fromFirestore(user.docs.first);

      utilisateurCourant = utilisateur;
      await getResultat(utilisateurCourant?.id);
      isConnect = true;
      notifyListeners();
    } else {
      utilisateurCourant = null;
      isConnect = false;
      notifyListeners();
    }
  }

  Future<void> getResultat(String? userId) async {
    final CollectionReference resultat = FirebaseFirestore.instance.collection(
      'Resultat',
    );
    final result = await resultat.where('userId', isEqualTo: userId).get();
    resultats = result.docs
        .map((resul) => Resultat.fromFirestore(resul))
        .toList();
    notifyListeners();
  }

  bool estCoursTermine(String matiere) {
    // Vérifie si au moins un résultat dans la liste correspond à ce cours
    return resultats!.any((res) => res.matiere == matiere);
  }

  Future<void> inscriptionUser(
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

  Future<void> updateUser(String adressePostal, String motivation) async {
    await _user.doc(utilisateurCourant!.id).update({
      'adressePostal': adressePostal.trim(),
      'motivation': motivation,
    });
    utilisateurCourant = User(
      id: utilisateurCourant!.id,
      nom: utilisateurCourant!.nom,
      prenom: utilisateurCourant!.prenom,
      email: utilisateurCourant!.email,
      age: utilisateurCourant!.age,
      adressePostal: adressePostal,
      motivation: motivation,
    );
    notifyListeners();
  }

  Future<void> deleteUser(String id) async {
    await _user.doc(id).delete();
  }

  void deconnexionUser() {
    resultats = [];
    utilisateurCourant = null;
    isConnect = false;
    notifyListeners();
  }
}
