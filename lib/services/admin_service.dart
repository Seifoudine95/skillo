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

    UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: motDePasse,
      );
    } on FirebaseAuthException catch (error) {
      return switch (error.code) {
        "invalid-email" => "L'adresse e-mail n'est pas valide",
        "user-not-found" || "wrong-password" || "invalid-credential" => "Compte Firebase Authentication introuvable ou mot de passe incorrect",
        "network-request-failed" =>
          "Connexion impossible : vérifie ta connexion Internet",
        _ => "Échec de la connexion Firebase (${error.code})",
      };
    }

    final emailAuthentifie = credential.user?.email?.trim().toLowerCase();
    if (emailAuthentifie == null || emailAuthentifie.isEmpty) {
      await FirebaseAuth.instance.signOut();
      return "L'adresse e-mail du compte authentifié est introuvable";
    }

    try {
      final utilisateursParEmail = await FirebaseFirestore.instance
          .collection("User")
          .where("e-mail", isEqualTo: emailAuthentifie)
          .get();

      final utilisateursParChampHistorique = utilisateursParEmail.docs.isEmpty
          ? await FirebaseFirestore.instance
                .collection("User")
                .where("email", isEqualTo: emailAuthentifie)
                .get()
          : null;

      final utilisateurs =
          utilisateursParChampHistorique?.docs ?? utilisateursParEmail.docs;
      if (utilisateurs.isEmpty) {
        await FirebaseAuth.instance.signOut();
        return "Connecté avec $emailAuthentifie, mais aucun document "
            "User ne correspond à cette adresse dans e-mail/email.";
      }

      QueryDocumentSnapshot<Map<String, dynamic>>? documentAdministrateur;
      for (final document in utilisateurs) {
        final data = document.data();
        final emailDocument = (data["email"] ?? data["e-mail"] ?? "")
            .toString()
            .trim()
            .toLowerCase();
        if (emailDocument == emailAuthentifie) {
          documentAdministrateur = document;
          break;
        }
      }

      if (documentAdministrateur == null) {
        await FirebaseAuth.instance.signOut();
        return "Connecté avec $emailAuthentifie, mais aucun document "
            "User ne correspond exactement à cette adresse.";
      }

      final role = documentAdministrateur.data()["admin"];
      if (role != true) {
        await FirebaseAuth.instance.signOut();
        final typeRole = role == null ? "absent" : role.runtimeType.toString();
        return "Le document User est trouvé, mais admin "
            "n'est pas le booléen true (type actuel : $typeRole).";
      }

      return "";
    } on FirebaseException catch (error) {
      await FirebaseAuth.instance.signOut();
      return "Erreur lors de la vérification des droits : "
          "${error.message ?? error.code}";
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
