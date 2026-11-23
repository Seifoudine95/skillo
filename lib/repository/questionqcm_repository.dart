import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillo/models/question_model.dart';

class QuestionQcmRepository {
  final CollectionReference _question = FirebaseFirestore.instance.collection(
    'QuestionQcm',
  );

  Stream<List<QuestionQcm>> getQuestion(String matiere) {
    return _question.where('matiere', isEqualTo: matiere).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => QuestionQcm.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addQuestion(
    String matiereId,
    String question,
    List<String> options,
    String reponse,
  ) async {
    await _question.add({
      'matiereId': matiereId,
      'question': question,
      'options': options,
      'reponse': reponse,
    });
  }

  Future<void> updateQuestion(
    String id,
    String matiereId,
    String question,
    List<String> options,
    String reponse,
  ) async {
    await _question.doc(id).update({
      'matiereId': matiereId,
      'question': question,
      'options': options,
      'reponse': reponse,
    });
  }

  Future<void> deleteQuestion(String id) async {
    await _question.doc(id).delete();
  }
}
