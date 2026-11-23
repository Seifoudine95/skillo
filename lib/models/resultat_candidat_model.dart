class ResultatCandidat {
  const ResultatCandidat({
    required this.prenom,
    required this.nom,
    required this.matiere,
    required this.score,
    required this.totalQuestions,
    required this.date,
  });

  final String prenom;
  final String nom;
  final String matiere;
  final int score;
  final int totalQuestions;
  final DateTime date;
}
