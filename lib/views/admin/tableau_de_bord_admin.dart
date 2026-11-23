import 'package:material_ui/material_ui.dart';

class TableauDeBordAdmin extends StatelessWidget {
  const TableauDeBordAdmin({super.key});

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
        body: const Column(
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
                children: [_PageTableauDeBord(), _PageStatistiques()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageTableauDeBord extends StatelessWidget {
  const _PageTableauDeBord();

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
        const TextField(
          decoration: InputDecoration(
            labelText: 'Rechercher par nom ou prénom',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: 'Toutes',
          decoration: const InputDecoration(
            labelText: 'Année scolaire',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Toutes', child: Text('Toutes')),
            DropdownMenuItem(value: '2025-2026', child: Text('2025-2026')),
            DropdownMenuItem(value: '2026-2027', child: Text('2026-2027')),
          ],
          onChanged: null,
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Amina Diallo'),
            subtitle: Text('HTML / CSS · 8/10\n20/11/2026 · 2026-2027'),
            isThreeLine: true,
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Yanis Morel'),
            subtitle: Text('Java · 4/10\n18/11/2026 · 2026-2027'),
            isThreeLine: true,
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Camille Bernard'),
            subtitle: Text('Algorithmique · 9/10\n08/04/2026 · 2025-2026'),
            isThreeLine: true,
          ),
        ),
      ],
    );
  }
}

class _PageStatistiques extends StatelessWidget {
  const _PageStatistiques();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Réussite par matière',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: '2026-2027',
          decoration: const InputDecoration(
            labelText: 'Année scolaire',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: '2025-2026', child: Text('2025-2026')),
            DropdownMenuItem(value: '2026-2027', child: Text('2026-2027')),
          ],
          onChanged: null,
        ),
        const SizedBox(height: 12),
        const _PourcentageMatiere(nom: 'HTML / CSS', pourcentage: 80),
        const _PourcentageMatiere(nom: 'Java', pourcentage: 60),
        const _PourcentageMatiere(nom: 'Algorithmique', pourcentage: 75),
        const SizedBox(height: 16),
        const Text(
          'Réussite générale',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Card(
          child: ListTile(
            leading: _IndicateurPourcentage(pourcentage: 72),
            title: Text('72 % de réussite'),
            subtitle: Text('Pour tous les candidats de l’année sélectionnée'),
          ),
        ),
      ],
    );
  }
}

class _PourcentageMatiere extends StatelessWidget {
  const _PourcentageMatiere({required this.nom, required this.pourcentage});

  final String nom;
  final int pourcentage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _IndicateurPourcentage(pourcentage: pourcentage),
        title: Text(nom),
        subtitle: Text('$pourcentage % de réussite'),
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
