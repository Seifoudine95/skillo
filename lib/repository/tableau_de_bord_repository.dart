import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillo/models/resultat_model.dart';
import 'package:skillo/models/resultat_candidat_model.dart';
import 'package:skillo/models/user_model.dart';

class TableauDeBordRepository {
  TableauDeBordRepository({FirebaseFirestore? firestore})
    : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _database => _firestore ?? FirebaseFirestore.instance;

  CollectionReference get _resultats => _database.collection('Résultat');

  CollectionReference get _utilisateurs => _database.collection('Utilisateur');

  Stream<List<ResultatCandidat>> getResultats() {
    return _resultats.snapshots().asyncMap((snapshot) async {
      final resultats = <ResultatCandidat>[];

      for (final document in snapshot.docs) {
        final resultat = Resultat.fromFirestore(document);
        User? utilisateur;
        if (resultat.userId.isNotEmpty) {
          final utilisateurDocument = await _utilisateurs
              .doc(resultat.userId)
              .get();
          if (utilisateurDocument.exists) {
            utilisateur = User.fromFirestore(utilisateurDocument);
          }
        }

        resultats.add(
          ResultatCandidat(
            prenom: utilisateur?.prenom ?? '',
            nom:
                utilisateur?.nom ??
                (resultat.userId.isEmpty
                    ? 'Utilisateur inconnu'
                    : resultat.userId),
            matiere: resultat.matiere,
            score: resultat.score,
            totalQuestions: resultat.totalQuestions,
            date: resultat.datePassage,
          ),
        );
      }

      return resultats;
    });
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
          (resultat.date != null &&
              anneeScolaire(resultat.date!) == anneeSelectionnee);

      if (correspondAlaRecherche && correspondAlaAnnee) {
        liste.add(resultat);
      }
    }

    liste.sort((a, b) {
      if (a.date == null) {
        return b.date == null ? 0 : 1;
      }
      if (b.date == null) {
        return -1;
      }
      return b.date!.compareTo(a.date!);
    });
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
