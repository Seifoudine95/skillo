// LOGIQUE : story IV connexion de l'admin et accueil admin
// l'admin a un compte déjà créé à la main dans Firebase :
//  - dans Authentication (email + mot de passe)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillo/models/matiere_model.dart';
import 'package:skillo/models/resultat_model.dart';

class AdminService {
  // connexion de l'admin
 
  Future<String> connexion(String email, String motDePasse) async {
    if (email == "" || motDePasse == "") {
      return "Remplis l'email et le mot de passe";
    }
    try {
      // 1. on vérifie l'email et le mot de passe
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: motDePasse,
      );

      String uid = FirebaseAuth.instance.currentUser!.uid;

      // le compte doit être dans la collection "Admin"
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("Admin")
          .doc(uid)
          .get();

      if (doc.exists == false) {
        await FirebaseAuth.instance.signOut();
        return "Ce compte n'est pas administrateur";
      }

      return "";
    } catch (e) {
      return "Email ou mot de passe incorrect";
    }
  }

  // déconnexion de l'admin
  Future<void> deconnexion() async {
    await FirebaseAuth.instance.signOut();
  }

  // la liste des matières
  Future<List<Matiere>> chargerMatieres() async {
    QuerySnapshot resultat = await FirebaseFirestore.instance
        .collection("Matiere")
        .get();

    List<Matiere> matieres = [];
    for (int i = 0; i < resultat.docs.length; i++) {
      matieres.add(Matiere.fromFirestore(resultat.docs[i]));
    }
    return matieres;
  }

  // ajouter une matière
  // renvoie "" si c'est bon, sinon le message d'erreur
  Future<String> ajouterMatiere(String nom, String description) async {
    if (nom == "") {
      return "Le nom de la matière est obligatoire";
    }

    await FirebaseFirestore.instance.collection("Matiere").add({
      "nom": nom,
      "description": description,
    });
    return "";
  }

  // les résultats de tous les candidats
  Future<List<Resultat>> chargerResultats() async {
    QuerySnapshot resultat = await FirebaseFirestore.instance
        .collection("Resultat")
        .get();

    List<Resultat> liste = [];
    for (int i = 0; i < resultat.docs.length; i++) {
      liste.add(Resultat.fromFirestore(resultat.docs[i]));
    }
    return liste;
  }

  // les noms des candidats, pour les afficher à côté des résultats
  Future<Map<String, String>> chargerNomsCandidats() async {
    QuerySnapshot resultat = await FirebaseFirestore.instance
        .collection("User")
        .get();

    Map<String, String> noms = {};
    for (int i = 0; i < resultat.docs.length; i++) {
      Map<String, dynamic> data =
          resultat.docs[i].data() as Map<String, dynamic>;
      noms[resultat.docs[i].id] = "${data["prenom"]} ${data["nom"]}";
    }
    return noms;
  }
}