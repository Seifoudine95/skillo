import 'package:skillo/models/resultat_candidat_model.dart';

class TableauDeBordRepository {
  List<ResultatCandidat> getResultats() {
    return [
      ResultatCandidat(
        prenom: 'Ami',
        nom: 'Diallo',
        matiere: 'HTML / CSS',
        score: 8,
        totalQuestions: 10,
        date: DateTime(2026, 11, 20),
      ),
      ResultatCandidat(
        prenom: 'Yanis',
        nom: 'Morel',
        matiere: 'Java',
        score: 4,
        totalQuestions: 10,
        date: DateTime(2026, 11, 18),
      ),
      ResultatCandidat(
        prenom: 'Camille',
        nom: 'Bernard',
        matiere: 'Algorithmique',
        score: 9,
        totalQuestions: 10,
        date: DateTime(2026, 4, 8),
      ),
    ];
  }

  List<ResultatCandidat> filtrerResultats(
    List<ResultatCandidat> resultats,
    String recherche,
    String anneeSelectionnee,
  ) {
    final liste = <ResultatCandidat>[];

    for (final resultat in resultats) {
      final nomComplet = '${resultat.prenom} ${resultat.nom}'.toLowerCase();
      final correspondAlaRecherche = nomComplet.contains(
        recherche.toLowerCase(),
      );
      final correspondAlaAnnee =
          anneeSelectionnee == 'Toutes' ||
          anneeScolaire(resultat.date) == anneeSelectionnee;

      if (correspondAlaRecherche && correspondAlaAnnee) {
        liste.add(resultat);
      }
    }

    liste.sort((a, b) => b.date.compareTo(a.date));
    return liste;
  }

  List<String> getMatieres(List<ResultatCandidat> resultats) {
    final matieres = <String>[];

    for (final resultat in resultats) {
      if (!matieres.contains(resultat.matiere)) {
        matieres.add(resultat.matiere);
      }
    }

    return matieres;
  }

  int compterReussites(List<ResultatCandidat> resultats) {
    var nombreDeReussites = 0;

    for (final resultat in resultats) {
      if (aReussi(resultat)) {
        nombreDeReussites++;
      }
    }

    return nombreDeReussites;
  }

  int calculerTauxReussite(List<ResultatCandidat> resultats) {
    if (resultats.isEmpty) {
      return 0;
    }

    return (compterReussites(resultats) * 100 / resultats.length).round();
  }

  List<ResultatCandidat> filtrerParMatiere(
    List<ResultatCandidat> resultats,
    String matiere,
  ) {
    final liste = <ResultatCandidat>[];

    for (final resultat in resultats) {
      if (resultat.matiere == matiere) {
        liste.add(resultat);
      }
    }

    return liste;
  }

  bool aReussi(ResultatCandidat resultat) {
    if (resultat.totalQuestions == 0) {
      return false;
    }

    return resultat.score * 2 >= resultat.totalQuestions;
  }

  String anneeScolaire(DateTime date) {
    final anneeDebut = date.month >= 9 ? date.year : date.year - 1;
    return '$anneeDebut-${anneeDebut + 1}';
  }
}
