// logique : story II 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillo/models/matiere_model.dart';
import 'package:skillo/models/question_model.dart';

class TestService {
  // l'id du candidat connecté 
  Future<String> idCandidat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");
    if (id == null) {
      return "";
    }
    return id;
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

  //  candidat  peut passer un test qu'une seule fois
  Future<bool> testDejaPasse(String nomMatiere) async {
    String id = await idCandidat();

    QuerySnapshot resultat = await FirebaseFirestore.instance
        .collection("Resultat")
        .where("userId", isEqualTo: id)
        .where("matiere", isEqualTo: nomMatiere)
        .get();

    if (resultat.docs.isEmpty) {
      return false;
    }
    return true;
  }

  // les questions d'une matière
  Future<List<QuestionQcm>> chargerQuestions(String nomMatiere) async {
    QuerySnapshot resultat = await FirebaseFirestore.instance
        .collection("QuestionQcm")
        .where("matiere", isEqualTo: nomMatiere)
        .get();

    List<QuestionQcm> questions = [];
    for (int i = 0; i < resultat.docs.length; i++) {
      questions.add(QuestionQcm.fromFirestore(resultat.docs[i]));
    }
    return questions;
  }

  // quand le candidat clique sur une réponse
  // radio = garde que la réponse qui est cliqué
  // checkbox = ajoute la réponse ou enlève si  déjà cochée
  List<String> choisirReponse(List<String> choix, String option, String type) {
    List<String> nouveauChoix = [];

    if (type == "radio") {
      nouveauChoix.add(option);
      return nouveauChoix;
    }

    for (int i = 0; i < choix.length; i++) {
      nouveauChoix.add(choix[i]);
    }
    if (nouveauChoix.contains(option)) {
      nouveauChoix.remove(option);
    } else {
      nouveauChoix.add(option);
    }
    return nouveauChoix;
  }

  // renvoie true = candidat coché les bonnes réponses
  bool estBonneReponse(List<String> choix, List<String> bonnes) {
    if (choix.length != bonnes.length) {
      return false;
    }
    for (int i = 0; i < choix.length; i++) {
      if (!bonnes.contains(choix[i])) {
        return false;
      }
    }
    return true;
  }

  // on enregistre le résultat
  Future<void> enregistrerResultat(
    String nomMatiere,
    int score,
    int totalQuestions,
  ) async {
    String id = await idCandidat();

    await FirebaseFirestore.instance.collection("Resultat").add({
      "userId": id,
      "matiere": nomMatiere,
      "score": score,
      "totalQuestions": totalQuestions,
      "datePassage": DateTime.now(),
    });
  }
}