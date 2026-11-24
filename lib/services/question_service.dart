// logique : story V ajouter, modifier, supprimer des questions
// exporter et importer un JSON pour réinitialiser une matière

import 'dart:convert'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillo/models/question_model.dart';

class QuestionService {
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

  // ajouter  ou modifier  une question
  Future<String> enregistrer(
    String id,
    String nomMatiere,
    String texteQuestion,
    String type,
    String temps,
    List<String> textesOptions,
    List<bool> bonnesReponses,
  ) async {
    // le temps doit être un nombre
    int? tempsLimite = int.tryParse(temps);
    if (tempsLimite == null) {
      return "Le temps limite doit être un nombre";
    }

    // on récupère les réponses proposées et les bonnes réponses
    List<String> options = [];
    List<String> reponses = [];
    for (int i = 0; i < textesOptions.length; i++) {
      String texte = textesOptions[i].trim();
      options.add(texte);
      if (bonnesReponses[i] == true) {
        reponses.add(texte);
      }
    }

    QuestionQcm question = QuestionQcm(
      id: id,
      matiere: nomMatiere,
      question: texteQuestion.trim(),
      options: options,
      type: type,
      reponses: reponses,
      tempsLimite: tempsLimite,
    );

    // on vérifie la question avant de l'enregistrer
    String erreur = question.verifier();
    if (erreur != "") {
      return erreur;
    }

    if (id == "") {
      // nouvelle question
      await FirebaseFirestore.instance
          .collection("QuestionQcm")
          .add(question.toJson());
    } else {
      // question existante : on la modifie
      await FirebaseFirestore.instance
          .collection("QuestionQcm")
          .doc(id)
          .update(question.toJson());
    }
    return "";
  }

  // supprimer une question
  Future<void> supprimer(String id) async {
    await FirebaseFirestore.instance.collection("QuestionQcm").doc(id).delete();
  }

  // transforme les questions en texte JSON
  String exporterJson(List<QuestionQcm> questions) {
    List<Map<String, dynamic>> liste = [];
    for (int i = 0; i < questions.length; i++) {
      Map<String, dynamic> map = questions[i].toJson();
      map.remove("matiere"); // la matière est choisie au moment de l'import
      liste.add(map);
    }
    return jsonEncode(liste);
  }


  // on supprime les anciennes questions et on ajoute celles du JSON
  Future<String> importerJson(String texte, String nomMatiere) async {
    // 1. on lit et on vérifie le JSON (on ne touche à rien s'il y a une erreur)
    ResultatImport resultat = lireJson(texte, nomMatiere);
    if (resultat.erreur != "") {
      return resultat.erreur;
    }
    List<QuestionQcm> nouvelles = resultat.questions;

    // on supprime les anciennes questions de la matière
    List<QuestionQcm> anciennes = await chargerQuestions(nomMatiere);
    for (int i = 0; i < anciennes.length; i++) {
      await supprimer(anciennes[i].id);
    }

    //  on ajoute des nouvelles questions
    for (int i = 0; i < nouvelles.length; i++) {
      await FirebaseFirestore.instance
          .collection("QuestionQcm")
          .add(nouvelles[i].toJson());
    }

    return "";
  }
}

// le résultat de la lecture d'un JSON :
class ResultatImport {
  List<QuestionQcm> questions = [];
  String erreur = "";
}

// lit le texte JSON et le transforme en liste de questions
ResultatImport lireJson(String texte, String nomMatiere) {
  ResultatImport resultat = ResultatImport();

  try {
    List liste = jsonDecode(texte);

    for (int i = 0; i < liste.length; i++) {
      Map data = liste[i];

      String type = "radio";
      if (data["type"] != null) {
        type = data["type"];
      }

      // le temps 
      int tempsLimite = 30;
      if (data["tempsLimite"] != null) {
        tempsLimite = data["tempsLimite"];
      }

      QuestionQcm question = QuestionQcm(
        id: "",
        matiere: nomMatiere,
        question: data["question"],
        options: List<String>.from(data["options"]),
        type: type,
        reponses: List<String>.from(data["reponses"]),
        tempsLimite: tempsLimite,
      );

      // on vérifie chaque question
      String erreur = question.verifier();
      if (erreur != "") {
        resultat.erreur = "Question ${i + 1} : $erreur";
        return resultat;
      }

      resultat.questions.add(question);
    }
  } catch (e) {
    resultat.erreur = "Le JSON n'est pas correct, regarde l'exemple";
    return resultat;
  }

  if (resultat.questions.isEmpty) {
    resultat.erreur = "Le JSON ne contient aucune question";
  }
  return resultat;
}
