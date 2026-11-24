// vue: résultats  candidats admin
// logique = admin_service.dart

import 'package:material_ui/material_ui.dart';
import 'package:skillo/models/resultat_model.dart';
import 'package:skillo/services/admin_service.dart';

class ResultatsAdmin extends StatefulWidget {
  const ResultatsAdmin({super.key});

  @override
  State<ResultatsAdmin> createState() => _ResultatsAdminState();
}

class _ResultatsAdminState extends State<ResultatsAdmin> {
  AdminService service = AdminService();

  List<Resultat> resultats = [];
  Map<String, String> noms = {};
  bool chargement = true;

  @override
  void initState() {
    super.initState();
    chargerResultats();
  }

  Future<void> chargerResultats() async {
    List<Resultat> liste = await service.chargerResultats();
    Map<String, String> listeNoms = await service.chargerNomsCandidats();

    if (!mounted) {
      return;
    }

    setState(() {
      resultats = liste;
      noms = listeNoms;
      chargement = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget contenu;

    if (chargement == true) {
      contenu = Center(child: CircularProgressIndicator());
    } else if (resultats.isEmpty) {
      contenu = Center(child: Text("Aucun résultat pour le moment"));
    } else {
      List<Widget> lignes = [];
      for (int i = 0; i < resultats.length; i++) {
        Resultat r = resultats[i];

        // cherche  nom candidat avec id
        String nomCandidat = "Candidat inconnu";
        if (noms.containsKey(r.userId)) {
          nomCandidat = noms[r.userId]!;
        }

        lignes.add(
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(nomCandidat),
              subtitle: Text(r.matiere),
              trailing: Text(
                "${r.score} / ${r.totalQuestions}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }
      contenu = ListView(padding: EdgeInsets.all(20), children: lignes);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Résultats des candidats")),
      body: contenu,
    );
  }
}