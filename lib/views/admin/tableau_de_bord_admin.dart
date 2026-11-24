import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillo/models/resultat_candidat_model.dart';
import 'package:skillo/providers/providers.dart';
import 'package:skillo/repository/tableau_de_bord_repository.dart';

class TableauDeBordAdmin extends ConsumerStatefulWidget {
  const TableauDeBordAdmin({super.key});

  @override
  ConsumerState<TableauDeBordAdmin> createState() => _TableauDeBordAdminState();
}

class _TableauDeBordAdminState extends ConsumerState<TableauDeBordAdmin> {
  String recherche = '';
  String anneeSelectionnee = 'Toutes';

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tableauDeBordRepositoryProvider);
    final resultats = ref.watch(getResultatAdminProvider);

    return resultats.when(
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Erreur lors du chargement : $error')),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      data: (donnees) {
        final resultatsFiltres = repository.filtrerResultats(
          donnees,
          recherche,
          anneeSelectionnee,
        );

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Administration',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.admin_panel_settings,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
                          indicatorColor: Colors.white,
                          tabs: [
                            Tab(text: 'Tableau de bord'),
                            Tab(text: 'Statistiques'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _PageTableauDeBord(
                          resultats: resultatsFiltres,
                          anneeSelectionnee: anneeSelectionnee,
                          repository: repository,
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
                          resultats: donnees,
                          anneeSelectionnee: anneeSelectionnee,
                          onAnneeChangee: (value) {
                            setState(() {
                              anneeSelectionnee = value;
                            });
                          },
                          repository: repository,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PageTableauDeBord extends StatelessWidget {
  const _PageTableauDeBord({
    required this.resultats,
    required this.anneeSelectionnee,
    required this.repository,
    required this.onRechercheChangee,
    required this.onAnneeChangee,
  });

  final List<ResultatCandidat> resultats;
  final String anneeSelectionnee;
  final TableauDeBordRepository repository;
  final ValueChanged<String> onRechercheChangee;
  final ValueChanged<String> onAnneeChangee;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('dashboardList'),
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
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: Text('${resultat.prenom} ${resultat.nom}'),
                subtitle: Text(
                  '${resultat.matiere} · ${resultat.score}/${resultat.totalQuestions}'
                  '\n${_dateTexte(resultat.date)} · '
                  '${resultat.date == null ? 'Année inconnue' : repository.anneeScolaire(resultat.date!)}',
                ),
                isThreeLine: true,
              ),
            ),
      ],
    );
  }
}

String _dateTexte(DateTime? date) {
  if (date == null) {
    return 'Date inconnue';
  }

  final jour = date.day.toString().padLeft(2, '0');
  final mois = date.month.toString().padLeft(2, '0');
  return '$jour/$mois/${date.year}';
}

class _PageStatistiques extends StatelessWidget {
  const _PageStatistiques({
    required this.resultats,
    required this.anneeSelectionnee,
    required this.onAnneeChangee,
    required this.repository,
  });

  final List<ResultatCandidat> resultats;
  final String anneeSelectionnee;
  final ValueChanged<String> onAnneeChangee;
  final TableauDeBordRepository repository;

  @override
  Widget build(BuildContext context) {
    final resultatsFiltres = repository.filtrerResultats(
      resultats,
      '',
      anneeSelectionnee,
    );
    final matieres = repository.getMatieres(resultatsFiltres);
    final nombreDeReussites = repository.compterReussites(resultatsFiltres);
    final tauxGeneral = repository.calculerTauxReussite(resultatsFiltres);

    return ListView(
      key: const ValueKey('statisticsList'),
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
        const _LegendeCamembert(),
        const SizedBox(height: 8),
        if (matieres.isEmpty)
          const Text('Aucun résultat pour cette année scolaire.')
        else
          for (final matiere in matieres)
            _statistiqueMatiere(matiere, resultatsFiltres),
        const SizedBox(height: 16),
        const Text(
          'Réussite générale',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Card(
          child: ListTile(
            leading: _CamembertReussite(
              pourcentage: tauxGeneral,
              key: const ValueKey('tauxGeneralCamembert'),
            ),
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

  Widget _statistiqueMatiere(
    String matiere,
    List<ResultatCandidat> resultatsFiltres,
  ) {
    final resultatsMatiere = repository.filtrerParMatiere(
      resultatsFiltres,
      matiere,
    );
    final reussites = repository.compterReussites(resultatsMatiere);
    final taux = repository.calculerTauxReussite(resultatsMatiere);

    return _PourcentageMatiere(
      nom: matiere,
      pourcentage: taux,
      nombreDeReussites: reussites,
      nombreDeResultats: resultatsMatiere.length,
      key: ValueKey('camembert-$matiere'),
    );
  }
}

class _LegendeCamembert extends StatelessWidget {
  const _LegendeCamembert();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _ElementLegendeCamembert(
          couleur: Colors.blue,
          texte: 'Réussite',
        ),
        SizedBox(width: 16),
        _ElementLegendeCamembert(
          couleur: Colors.black12,
          texte: 'Échec',
        ),
      ],
    );
  }
}

class _ElementLegendeCamembert extends StatelessWidget {
  const _ElementLegendeCamembert({
    required this.couleur,
    required this.texte,
  });

  final Color couleur;
  final String texte;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: couleur, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(texte),
      ],
    );
  }
}

class _PourcentageMatiere extends StatelessWidget {
  const _PourcentageMatiere({
    super.key,
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
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: _CamembertReussite(
          pourcentage: pourcentage,
          key: ValueKey('camembert-visuel-$nom'),
        ),
        title: Text(nom),
        subtitle: Text(
          '$pourcentage % · $nombreDeReussites réussite(s) sur '
          '$nombreDeResultats résultat(s)',
        ),
      ),
    );
  }
}

class _CamembertReussite extends StatelessWidget {
  const _CamembertReussite({super.key, required this.pourcentage});

  final int pourcentage;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Camembert de réussite : $pourcentage %',
      child: SizedBox(
        width: 56,
        height: 56,
        child: CustomPaint(
          painter: _CamembertPainter(pourcentage: pourcentage),
        ),
      ),
    );
  }
}

class _CamembertPainter extends CustomPainter {
  const _CamembertPainter({required this.pourcentage});

  final int pourcentage;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final centre = Offset(size.width / 2, size.height / 2);
    final rayon = math.min(size.width, size.height) / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    if (pourcentage <= 0) {
      paint.color = Colors.black12;
      canvas.drawCircle(centre, rayon, paint);
      return;
    }

    if (pourcentage >= 100) {
      paint.color = Colors.blue;
      canvas.drawCircle(centre, rayon, paint);
      return;
    }

    paint.color = Colors.black12;
    canvas.drawCircle(centre, rayon, paint);

    paint.color = Colors.blue;
    final angleReussite = 2 * math.pi * pourcentage / 100;
    canvas.drawArc(bounds, -math.pi / 2, angleReussite, true, paint);
  }

  @override
  bool shouldRepaint(_CamembertPainter oldDelegate) {
    return oldDelegate.pourcentage != pourcentage;
  }
}
