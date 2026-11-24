import 'package:cloud_firestore/cloud_firestore.dart';

class Matiere {
  final String id;
  final String nom;
  final String description;

  Matiere({required this.id, required this.nom, this.description = ''});

  // on crée une matière avec un document Firestore
  factory Matiere.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Matiere(
      id: doc.id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'nom': nom, 'description': description};
  }
}