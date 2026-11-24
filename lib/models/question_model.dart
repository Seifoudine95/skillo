// question de QCM
//admin crée les questions

import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionQcm {
  String id;
  String matiere; // le nom de la matière
  String question; // le texte de la question
  List<String> options; // les réponses proposées
  String type; // "radio" = une seule réponse, "checkbox" = plusieurs
  List<String> reponses; // les bonnes réponses
  int tempsLimite; // le temps en secondes

  QuestionQcm({
    required this.id,
    required this.matiere,
    required this.question,
    required this.options,
    required this.type,
    required this.reponses,
    required this.tempsLimite,
  });

  // transforme un document  en QuestionQcm
  factory QuestionQcm.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // les bonnes réponses 
    List<String> reponses = [];
    if (data["reponses"] != null) {
      reponses = List<String>.from(data["reponses"]);
    }

    // le type 
    String type = "radio";
    if (data["type"] == "checkbox") {
      type = "checkbox";
    }

    // le temps 
    int tempsLimite = 30;
    if (data["tempsLimite"] != null) {
      tempsLimite = data["tempsLimite"];
    }

    return QuestionQcm(
      id: doc.id,
      matiere: data["matiere"],
      question: data["question"],
      options: List<String>.from(data["options"]),
      type: type,
      reponses: reponses,
      tempsLimite: tempsLimite,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      "matiere": matiere,
      "question": question,
      "options": options,
      "type": type,
      "reponses": reponses,
      "tempsLimite": tempsLimite,
    };
  }

  // STORY V : vérifie que la question est correcte

  String verifier() {
    if (question == "") {
      return "La question est vide";
    }
    if (type != "radio" && type != "checkbox") {
      return "Le type doit être radio ou checkbox";
    }
    if (options.length < 2) {
      return "Il faut au moins 2 réponses proposées";
    }
    for (int i = 0; i < options.length; i++) {
      if (options[i] == "") {
        return "Une réponse proposée est vide";
      }
    }
    if (reponses.isEmpty) {
      return "Coche au moins une bonne réponse";
    }
    for (int i = 0; i < reponses.length; i++) {
      if (!options.contains(reponses[i])) {
        return "Une bonne réponse n'est pas dans les réponses proposées";
      }
    }
    if (type == "radio" && reponses.length > 1) {
      return "Une question radio a une seule bonne réponse";
    }
    if (tempsLimite <= 0) {
      return "Le temps limite doit être plus grand que 0";
    }
    return "";
  }
}
