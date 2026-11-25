import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:skillo/models/resultat_model.dart';

class ResultatRepository extends ChangeNotifier {
  final CollectionReference _resultat = FirebaseFirestore.instance.collection(
    'Resultat',
  );

  // List<Resultat>? resultats;

  // Future<void> getResultat(String userId) async {
  //   final result = await _resultat.where('userId', isEqualTo: userId).get();
  //   resultats = result.docs
  //       .map((resul) => Resultat.fromFirestore(resul))
  //       .toList();
  //   notifyListeners();
  // }

  Future<void> addResulta(
    String userId,
    String matiere,
    int score,
    int totalQuestions,
    DateTime? datePassage,
  ) async {
    await _resultat.add({
      'userId': userId,
      'matiere': matiere,
      'score': score,
      'totalQuestions': totalQuestions,
      'datePassage': datePassage,
    });
  }
  
}

