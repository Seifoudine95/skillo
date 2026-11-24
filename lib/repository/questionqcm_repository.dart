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

  Future<void> addQuestion(QuestionQcm question) async {
    await _question.add(question.toJson());
  }

  Future<void> updateQuestion(QuestionQcm question) async {
    await _question.doc(question.id).update(question.toJson());
  }

  Future<void> deleteQuestion(String id) async {
    await _question.doc(id).delete();
  }

  // supprime toutes les questions de la matière et les remplace (import JSON)
  Future<void> remplacerQuestions(
    String matiere,
    List<QuestionQcm> questions,
  ) async {
    final anciennes = await _question.where('matiere', isEqualTo: matiere).get();

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in anciennes.docs) {
      batch.delete(doc.reference);
    }
    for (final q in questions) {
      batch.set(_question.doc(), q.toJson());
    }
    await batch.commit();
  }
}
