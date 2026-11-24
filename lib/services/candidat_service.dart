// le candidat se connecte avec son nom + son email

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillo/models/resultat_model.dart';
import 'package:skillo/models/user_model.dart';

class CandidatService {
  // les 3 choix de motivation
  List<String> motivations = [
    "Poursuite d'étude",
    "Reconversion pro",
    "Réorientation",
  ];

  // STORY I : inscription
  // renvoie "" si c'est bon, sinon le message d'erreur
  Future<String> inscrire(
    String nom,
    String prenom,
    String email,
    String age,
    String adresse,
    String? motivation,
  ) async {
    // critère : tous les champs sont obligatoires
    if (nom == "") {
      return "Le nom est obligatoire";
    }
    if (prenom == "") {
      return "Le prénom est obligatoire";
    }
    if (email == "") {
      return "L'email est obligatoire";
    }
    if (age == "") {
      return "L'âge est obligatoire";
    }
    if (adresse == "") {
      return "L'adresse postale est obligatoire";
    }
    if (motivation == null) {
      return "Choisis une motivation";
    }

    // les informations doivent être correctes
    if (EmailValidator.validate(email) == false) {
      return "L'email n'est pas correct";
    }
    if (int.tryParse(age) == null) {
      return "L'âge doit être un nombre";
    }

    // un seul compte avec ce nom et cet email
    QuerySnapshot resultat = await FirebaseFirestore.instance
        .collection("User")
        .where("nom", isEqualTo: nom)
        .where("email", isEqualTo: email)
        .get();

    if (resultat.docs.isNotEmpty) {
      return "Un compte existe déjà avec ce nom et cet email";
    }

    // on enregistre le candidat 
    DocumentReference doc = await FirebaseFirestore.instance
        .collection("User")
        .add({
          "nom": nom,
          "prenom": prenom,
          "email": email,
          "age": age,
          "adressePostal": adresse,
          "motivation": motivation,
        });

    // le candidat est connecté juste après l'inscription
    await sauvegarderConnexion(doc.id, nom, prenom, email, age, motivation);

    return "";
  }

  // connexion
  Future<String> connexion(String nom, String email) async {
    if (nom == "" || email == "") {
      return "Remplis le nom et l'email";
    }

    // on cherche le candidat dans la base
    QuerySnapshot resultat = await FirebaseFirestore.instance
        .collection("User")
        .where("nom", isEqualTo: nom)
        .where("email", isEqualTo: email)
        .get();

    // aucun candidat trouvé
    if (resultat.docs.isEmpty) {
      return "Aucun compte avec ce nom et cet email";
    }

    // on prend le premier candidat trouvé
    User candidat = User.fromFirestore(resultat.docs[0]);

    await sauvegarderConnexion(
      candidat.id,
      candidat.nom,
      candidat.prenom,
      candidat.email,
      candidat.age,
      candidat.motivation,
    );

    return "";
  }

  // on garde le candidat connecté dans le téléphone
  Future<void> sauvegarderConnexion(
    String id,
    String nom,
    String prenom,
    String email,
    String age,
    String motivation,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isConnect", true);
    await prefs.setString("id", id);
    await prefs.setString("nom", nom);
    await prefs.setString("prenom", prenom);
    await prefs.setString("mail", email);
    await prefs.setString("age", age);
    await prefs.setString("motivation", motivation);
  }

  // renvoie l'id du candidat connecté 
  Future<String> idCandidat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");
    if (id == null) {
      return "";
    }
    return id;
  }

  // déconnexion 
  Future<void> deconnexion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ---------- STORY III : profil ----------

  // les informations du candidat connecté (null si on ne le trouve pas)
  Future<User?> chargerProfil() async {
    String id = await idCandidat();
    if (id == "") {
      return null;
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .get();

    if (doc.exists == false) {
      return null;
    }
    return User.fromFirestore(doc);
  }

  // critère 1 : les résultats des tests du candidat connecté
  Future<List<Resultat>> chargerResultats() async {
    String id = await idCandidat();

    QuerySnapshot resultat = await FirebaseFirestore.instance
        .collection("Resultat")
        .where("userId", isEqualTo: id)
        .get();

    List<Resultat> liste = [];
    for (int i = 0; i < resultat.docs.length; i++) {
      liste.add(Resultat.fromFirestore(resultat.docs[i]));
    }
    return liste;
  }

  //  modifier l'adresse et la motivation
  // renvoie "" si c'est bon, sinon le message d'erreur
  Future<String> modifierProfil(String adresse, String? motivation) async {
    if (adresse == "") {
      return "L'adresse postale est obligatoire";
    }
    if (motivation == null) {
      return "Choisis une motivation";
    }

    String id = await idCandidat();
    if (id == "") {
      return "Tu n'es pas connecté";
    }

    await FirebaseFirestore.instance.collection("User").doc(id).update({
      "adressePostal": adresse,
      "motivation": motivation,
    });

    // met à jour la motivation 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("motivation", motivation);

    return "";
  }
}