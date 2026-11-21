import 'package:cloud_firestore/cloud_firestore.dart';

class Resultat {
  final String? id;
  final String userId;
  final String matiereId;
  final String matiere;
  final int score;
  final int totalQuestions;
  final DateTime? datePassage;

  Resultat({
    this.id,
    required this.userId,
    required this.matiereId,
    required this.matiere,
    required this.score,
    required this.totalQuestions,
    this.datePassage,
  });

  factory Resultat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Resultat(
      id: doc.id,
      userId: data['userId'] ?? '',
      matiereId: data['matiereId'] ?? '',
      matiere: data['matiere'] ?? '',
      score: data['score'] ?? 0,
      totalQuestions: data['totalQuestions'] ?? 0,
      datePassage:
          (data['datePassage'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'matiereId': matiereId,
      'matiere': matiere,
      'score': score,
      'totalQuestions': totalQuestions,
    };
  }
}
