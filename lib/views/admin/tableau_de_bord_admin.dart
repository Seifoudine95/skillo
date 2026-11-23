import 'package:material_ui/material_ui.dart';

class TableauDeBordAdmin extends StatefulWidget {
  const TableauDeBordAdmin({super.key});

  @override
  State<TableauDeBordAdmin> createState() => _TableauDeBordAdminState();
}

class _TableauDeBordAdminState extends State<TableauDeBordAdmin> {
  final List<_ResultatCandidat> resultats = [
    _ResultatCandidat(
      prenom: 'Amina',
      nom: 'Diallo',
      matiere: 'HTML / CSS',
      score: 8,
      totalQuestions: 10,
      date: DateTime(2026, 11, 20),
    ),
    _ResultatCandidat(
      prenom: 'Yanis',
      nom: 'Morel',
      matiere: 'Java',
      score: 4,
      totalQuestions: 10,
      date: DateTime(2026, 11, 18),
    ),
    _ResultatCandidat(
      prenom: 'Camille',
      nom: 'Bernard',
      matiere: 'Algorithmique',
      score: 9,
      totalQuestions: 10,
      date: DateTime(2026, 4, 8),
    ),
  ];

  String recherche = '';
  String anneeSelectionnee = 'Toutes';

  List<_ResultatCandidat> get resultatsFiltres {
    final liste = <_ResultatCandidat>[];

    for (final resultat in resultats) {
      final nomComplet = '${resultat.prenom} ${resultat.nom}'.toLowerCase();
      final correspondAlaRecherche = nomComplet.contains(
        recherche.toLowerCase(),
      );
      final correspondAlaAnnee =
          anneeSelectionnee == 'Toutes' ||
          _anneeScolaire(resultat.date) == anneeSelectionnee;

      if (correspondAlaRecherche && correspondAlaAnnee) {
        liste.add(resultat);
      }
    }

    liste.sort((a, b) => b.date.compareTo(a.date));
    return liste;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Administration'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tableau de bord'),
              Tab(text: 'Statistiques'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Maquette : ces informations sont des exemples et ne viennent '
                'pas encore de Firebase.',
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _PageTableauDeBord(
                    resultats: resultatsFiltres,
                    anneeSelectionnee: anneeSelectionnee,
                    onRechercheChangee: (value) {
                      setState(() {
                        recherche = value;
                      });
                    },
                    onAnneeChangee: (value) {
                      setState(() {
                        anneeSelectionnee = value;
                      });
                    },
                  ),
                  _PageStatistiques(
                    resultats: resultats,
                    anneeSelectionnee: anneeSelectionnee,
                    onAnneeChangee: (value) {
                      setState(() {
                        anneeSelectionnee = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageTableauDeBord extends StatelessWidget {
  const _PageTableauDeBord({
    required this.resultats,
    required this.anneeSelectionnee,
    required this.onRechercheChangee,
    required this.onAnneeChangee,
  });

  final List<_ResultatCandidat> resultats;
  final String anneeSelectionnee;
  final ValueChanged<String> onRechercheChangee;
  final ValueChanged<String> onAnneeChangee;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Résultats récents',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: 'Rechercher par nom ou prénom',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: onRechercheChangee,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: anneeSelectionnee,
          decoration: const InputDecoration(
            labelText: 'Année scolaire',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Toutes', child: Text('Toutes')),
            DropdownMenuItem(value: '2025-2026', child: Text('2025-2026')),
            DropdownMenuItem(value: '2026-2027', child: Text('2026-2027')),
          ],
          onChanged: (value) {
            if (value != null) {
              onAnneeChangee(value);
            }
          },
        ),
        const SizedBox(height: 12),
        if (resultats.isEmpty)
          const Text('Aucun résultat trouvé.')
        else
          for (final resultat in resultats)
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('${resultat.prenom} ${resultat.nom}'),
                subtitle: Text(
                  '${resultat.matiere} · ${resultat.score}/${resultat.totalQuestions}'
                  '\n${_dateTexte(resultat.date)} · '
                  '${_anneeScolaire(resultat.date)}',
                ),
                isThreeLine: true,
              ),
            ),
      ],
    );
  }
}

class _ResultatCandidat {
  const _ResultatCandidat({
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

String _anneeScolaire(DateTime date) {
  final anneeDebut = date.month >= 9 ? date.year : date.year - 1;
  return '$anneeDebut-${anneeDebut + 1}';
}

String _dateTexte(DateTime date) {
  final jour = date.day.toString().padLeft(2, '0');
  final mois = date.month.toString().padLeft(2, '0');
  return '$jour/$mois/${date.year}';
}

class _PageStatistiques extends StatelessWidget {
  const _PageStatistiques({
    required this.resultats,
    required this.anneeSelectionnee,
    required this.onAnneeChangee,
  });

  final List<_ResultatCandidat> resultats;
  final String anneeSelectionnee;
  final ValueChanged<String> onAnneeChangee;

  List<_ResultatCandidat> get resultatsFiltres {
    final liste = <_ResultatCandidat>[];
    for (final resultat in resultats) {
      if (anneeSelectionnee == 'Toutes' ||
          _anneeScolaire(resultat.date) == anneeSelectionnee) {
        liste.add(resultat);
      }
    }
    return liste;
  }

  @override
  Widget build(BuildContext context) {
    final matieres = <String>[];
    for (final resultat in resultatsFiltres) {
      if (!matieres.contains(resultat.matiere)) {
        matieres.add(resultat.matiere);
      }
    }

    var nombreDeReussites = 0;
    for (final resultat in resultatsFiltres) {
      if (_aReussi(resultat)) {
        nombreDeReussites++;
      }
    }
    final tauxGeneral = resultatsFiltres.isEmpty
        ? 0
        : (nombreDeReussites * 100 / resultatsFiltres.length).round();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Réussite par matière',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: anneeSelectionnee,
          decoration: const InputDecoration(
            labelText: 'Année scolaire',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Toutes', child: Text('Toutes')),
            DropdownMenuItem(value: '2025-2026', child: Text('2025-2026')),
            DropdownMenuItem(value: '2026-2027', child: Text('2026-2027')),
          ],
          onChanged: (value) {
            if (value != null) {
              onAnneeChangee(value);
            }
          },
        ),
        const SizedBox(height: 12),
        if (matieres.isEmpty)
          const Text('Aucun résultat pour cette année scolaire.')
        else
          for (final matiere in matieres) _statistiqueMatiere(matiere),
        const SizedBox(height: 16),
        const Text(
          'Réussite générale',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Card(
          child: ListTile(
            leading: _IndicateurPourcentage(pourcentage: tauxGeneral),
            title: Text('$tauxGeneral % de réussite'),
            subtitle: Text(
              '$nombreDeReussites réussite(s) sur '
              '${resultatsFiltres.length} résultat(s)',
            ),
          ),
        ),
      ],
    );
  }

  Widget _statistiqueMatiere(String matiere) {
    var total = 0;
    var reussites = 0;

    for (final resultat in resultatsFiltres) {
      if (resultat.matiere == matiere) {
        total++;
        if (_aReussi(resultat)) {
          reussites++;
        }
      }
    }

    final taux = total == 0 ? 0 : (reussites * 100 / total).round();

    return _PourcentageMatiere(
      nom: matiere,
      pourcentage: taux,
      nombreDeReussites: reussites,
      nombreDeResultats: total,
    );
  }
}

bool _aReussi(_ResultatCandidat resultat) {
  if (resultat.totalQuestions == 0) {
    return false;
  }
  return resultat.score * 2 >= resultat.totalQuestions;
}

class _PourcentageMatiere extends StatelessWidget {
  const _PourcentageMatiere({
    required this.nom,
    required this.pourcentage,
    required this.nombreDeReussites,
    required this.nombreDeResultats,
  });

  final String nom;
  final int pourcentage;
  final int nombreDeReussites;
  final int nombreDeResultats;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _IndicateurPourcentage(pourcentage: pourcentage),
        title: Text(nom),
        subtitle: Text(
          '$pourcentage % · $nombreDeReussites réussite(s) sur '
          '$nombreDeResultats résultat(s)',
        ),
      ),
    );
  }
}

class _IndicateurPourcentage extends StatelessWidget {
  const _IndicateurPourcentage({required this.pourcentage});

  final int pourcentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(value: pourcentage / 100),
          Text('$pourcentage'),
        ],
      ),
    );
  }
}
