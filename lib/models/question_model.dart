import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionQcm {
  final String id;

  // nom de la matière 
  final String matiere;
  final String question;
  final List<String> options;

  final String type;

  // liste des bonnes réponses
  final List<String> reponses;

  // temps pour répondre (en secondes)
  final int tempsLimite;

  QuestionQcm({
    required this.id,
    required this.matiere,
    required this.question,
    required this.options,
    required this.type,
    required this.reponses,
    required this.tempsLimite,
  });

  factory QuestionQcm.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuestionQcm.fromMap(data, doc.id);
  }

  // crée une question à partir d'une Map 
  factory QuestionQcm.fromMap(Map<String, dynamic> data, String id) {
    List<String> reponses = [];
    if (data['reponses'] != null) {
      reponses = List<String>.from(data['reponses']);
    } else if (data['reponse'] != null && data['reponse'] != '') {
      // les anciennes questions avaient un seul champ "reponse"
      reponses = [data['reponse']];
    }

    return QuestionQcm(
      id: id,
      matiere: data['matiere'] ?? '',
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      type: data['type'] ?? 'radio',
      reponses: reponses,
      tempsLimite: data['tempsLimite'] ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matiere': matiere,
      'question': question,
      'options': options,
      'type': type,
      'reponses': reponses,
      'tempsLimite': tempsLimite,
    };
  }

  // vérifie que la question est correcte
  // renvoie un message d'erreur
  String? verifier() {
    if (question.trim().isEmpty) {
      return "L'intitulé de la question est vide.";
    }
    if (type != 'radio' && type != 'checkbox') {
      return 'Le type doit être "radio" ou "checkbox".';
    }
    if (options.length < 2) {
      return 'Il faut au moins 2 options.';
    }
    for (String option in options) {
      if (option.trim().isEmpty) {
        return 'Une option est vide.';
      }
    }
    if (reponses.isEmpty) {
      return 'Il faut indiquer au moins une bonne réponse.';
    }
    for (String reponse in reponses) {
      if (!options.contains(reponse)) {
        return 'La bonne réponse "$reponse" n\'est pas dans les options.';
      }
    }
    if (type == 'radio' && reponses.length > 1) {
      return 'Une question "radio" ne peut avoir qu\'une seule bonne réponse.';
    }
    if (tempsLimite <= 0) {
      return 'Le temps limite doit être plus grand que 0.';
    }
    return null;
  }
}