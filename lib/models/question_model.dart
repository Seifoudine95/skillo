import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionQcm {
  final String id;
  final String matiere;
  final String question;
  final List<String> options;
  final String reponse;

  QuestionQcm({
    required this.id,
    required this.matiere,
    required this.question,
    required this.options,
    required this.reponse,
  });

  factory QuestionQcm.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuestionQcm(
      id: doc.id,
      matiere: data['matiere'] ?? '',
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      reponse: data['reponse'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matiere': matiere,
      'question': question,
      'options': options,
      'reponse': reponse,
    };
  }
}
