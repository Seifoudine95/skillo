// VUE : story IV
// liste des matières + boutons : ajouter une matière, résultats, déconnexion
// la logique =admin_service.dart

import 'package:material_ui/material_ui.dart';
import 'package:skillo/models/matiere_model.dart';
import 'package:skillo/services/admin_service.dart';
import 'package:skillo/views/admin/ajouter_matiere.dart';
import 'package:skillo/views/admin/gestion_questions.dart';
import 'package:skillo/views/admin/resultats_admin.dart';
import 'package:skillo/views/utilisateur/connexion.dart';

class AcueilAdmin extends StatefulWidget {
  const AcueilAdmin({super.key});

  @override
  State<AcueilAdmin> createState() => _AcueilAdminState();
}

class _AcueilAdminState extends State<AcueilAdmin> {
  AdminService service = AdminService();

  List<Matiere> matieres = [];
  bool chargement = true;

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

  // ouvre la page "ajouter une matière"
  Future<void> ouvrirAjoutMatiere() async {
    // await : on attend que l'admin revienne sur cette page
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AjouterMatiere()),
    );
    // puis on recharge la liste pour voir la nouvelle matière
    chargerMatieres();
  }

  Future<void> seDeconnecter() async {
    await service.deconnexion();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Connexion()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget contenu;

    if (chargement == true) {
      contenu = Center(child: CircularProgressIndicator());
    } else if (matieres.isEmpty) {
      contenu = Center(child: Text("Aucune matière. Clique sur + pour en ajouter une."));
    } else {
      // une ligne par matière
      List<Widget> lignes = [];
      for (int i = 0; i < matieres.length; i++) {
        String nomMatiere = matieres[i].nom;
        lignes.add(
          Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text(nomMatiere),
              subtitle: Text(matieres[i].description),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // STORY V : gérer les questions 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GestionQuestions(nomMatiere: nomMatiere),
                  ),
                );
              },
            ),
          ),
        );
      }
      contenu = ListView(padding: EdgeInsets.all(20), children: lignes);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil administrateur"),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResultatsAdmin()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              seDeconnecter();
            },
          ),
        ],
      ),
      body: contenu,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ouvrirAjoutMatiere();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}