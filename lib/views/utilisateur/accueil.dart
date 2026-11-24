// vue story II: liste des matières pour le candidat 
// logique = test_service.dart

import 'package:material_ui/material_ui.dart';
import 'package:skillo/models/matiere_model.dart';
import 'package:skillo/services/test_service.dart';
import 'package:skillo/views/utilisateur/page_qsm.dart';
import 'package:skillo/views/utilisateur/profil_utilisateur.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  TestService service = TestService();

  List<Matiere> matieres = [];
  bool chargement = true;

  // initState est lancé une seule fois, à l'ouverture de la page
  @override
  void initState() {
    super.initState();
    chargerMatieres();
  }

  Future<void> chargerMatieres() async {
    List<Matiere> liste = await service.chargerMatieres();

    if (!mounted) {
      return;
    }

    setState(() {
      matieres = liste;
      chargement = false;
    });
  }

  // quand on clique sur une matière
  Future<void> ouvrirTest(String nomMatiere) async {
    bool dejaPasse = await service.testDejaPasse(nomMatiere);

    if (!mounted) {
      return;
    }

    if (dejaPasse == true) {
      //  un seul passage par test
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tu as déjà passé ce test")),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PageQsm(nomMat: nomMatiere)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Widget contenu;

    if (chargement == true) {
      contenu = Center(child: CircularProgressIndicator());
    } else if (matieres.isEmpty) {
      contenu = Center(child: Text("Pas de matière pour le moment"));
    } else {
      // ligne par matière
      List<Widget> lignes = [];
      for (int i = 0; i < matieres.length; i++) {
        String nomMatiere = matieres[i].nom;
        lignes.add(
          Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text(nomMatiere),
              subtitle: Text(matieres[i].description),
              onTap: () {
                ouvrirTest(nomMatiere);
              },
            ),
          ),
        );
      }
      contenu = ListView(padding: EdgeInsets.all(20), children: lignes);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenue sur Skillo"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // STORY III : bouton pour aller sur le profil
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilUtilisateur()),
              );
            },
          ),
        ],
      ),
      body: contenu,
    );
  }
}