import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillo/models/matiere_model.dart';

class MatiereRepository {
  final CollectionReference _matieres =
      FirebaseFirestore.instance.collection('Matiere');

  
  Stream<List<Matiere>> getMatiere() {
    return _matieres.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Matiere.fromFirestore(doc)).toList();
    });
  }

 
  Future<void> addMatiere(String nom, String description) async {
    await _matieres.add({
      'nom': nom,
      'description': description
    });
  }



  Future<void> updateMatiere(String id, String matiere) async {
    await _matieres.doc(id).update({'nom': matiere});
  }

  
  Future<void> deleteMatiere(String id) async {
    await _matieres.doc(id).delete();
  }
}