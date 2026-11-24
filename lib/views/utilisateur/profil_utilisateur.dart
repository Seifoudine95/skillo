// vue story 3:profil  candidat 
// voir scores, changer  adresse et motivation
// la logique = candidat_service.dart

import 'package:material_ui/material_ui.dart';
import 'package:skillo/models/resultat_model.dart';
import 'package:skillo/models/user_model.dart';
import 'package:skillo/services/candidat_service.dart';
import 'package:skillo/views/utilisateur/connexion.dart';

class ProfilUtilisateur extends StatefulWidget {
  const ProfilUtilisateur({super.key});

  @override
  State<ProfilUtilisateur> createState() => _ProfilUtilisateurState();
}

class _ProfilUtilisateurState extends State<ProfilUtilisateur> {
  CandidatService service = CandidatService();

  User? candidat; // rien si  profil pas chargé
  List<Resultat> resultats = [];
  bool chargement = true;

  TextEditingController adresseController = TextEditingController();
  String? motivation;
  String message = "";

  @override
  void initState() {
    super.initState();
    chargerProfil();
  }

  Future<void> chargerProfil() async {
    User? infos = await service.chargerProfil();
    List<Resultat> liste = await service.chargerResultats();

    if (!mounted) {
      return;
    }

    setState(() {
      candidat = infos;
      resultats = liste;
      chargement = false;

      // remplit le formulaire avec infos actuelles
      if (infos != null) {
        adresseController.text = infos.adressePostal;
        // met la motivation si elle fait partie des 3 choix
        if (service.motivations.contains(infos.motivation)) {
          motivation = infos.motivation;
        }
      }
    });
  }

  // enregistrer l'adresse et la motivation
  Future<void> enregistrer() async {
    String resultat = await service.modifierProfil(
      adresseController.text.trim(),
      motivation,
    );

    if (!mounted) {
      return;
    }

    if (resultat == "") {
      setState(() {
        message = "Informations enregistrées";
      });
      chargerProfil(); // recharge pour voir les nouvelles infos
    } else {
      setState(() {
        message = resultat;
      });
    }
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
    if (chargement == true) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // les textes du haut de la page
    String nomComplet = "Candidat";
    String texteMotivation = "";
    String texteAdresse = "";
    User? infos = candidat;
    if (infos != null) {
      nomComplet = "${infos.prenom} ${infos.nom}";
      texteMotivation = "Motivation : ${infos.motivation}";
      texteAdresse = "Adresse : ${infos.adressePostal}";
    }

    // les 3 choix de motivation
    List<DropdownMenuItem<String>> choix = [];
    for (int i = 0; i < service.motivations.length; i++) {
      choix.add(
        DropdownMenuItem(
          value: service.motivations[i],
          child: Text(service.motivations[i]),
        ),
      );
    }

    // on construit la liste de ce qu'on affiche
    List<Widget> enfants = [];

    enfants.add(
      Text(
        nomComplet,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
    enfants.add(Text(texteMotivation));
    enfants.add(Text(texteAdresse));
    enfants.add(SizedBox(height: 30));

    // partie "modifier"
    enfants.add(
      Text(
        "Modifier mes informations",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
    enfants.add(SizedBox(height: 10));
    enfants.add(
      TextField(
        controller: adresseController,
        decoration: InputDecoration(
          labelText: "Adresse postale",
          border: OutlineInputBorder(),
        ),
      ),
    );
    enfants.add(SizedBox(height: 10));
    enfants.add(
      DropdownButton<String>(
        value: motivation,
        hint: Text("Choisis ta motivation"),
        isExpanded: true,
        items: choix,
        onChanged: (valeur) {
          setState(() {
            motivation = valeur;
          });
        },
      ),
    );
    enfants.add(SizedBox(height: 10));
    enfants.add(
      ElevatedButton(
        onPressed: () {
          enregistrer();
        },
        child: Text("Enregistrer"),
      ),
    );
    enfants.add(Text(message));
    enfants.add(SizedBox(height: 30));

    //  les résultats des tests
    enfants.add(
      Text(
        "Mes résultats (${resultats.length} test(s) passé(s))",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );

    if (resultats.isEmpty) {
      enfants.add(Text("Aucun test passé pour le moment"));
    }

    for (int i = 0; i < resultats.length; i++) {
      Resultat r = resultats[i];

      // la date du test
      String texteDate = "";
      DateTime? date = r.datePassage;
      if (date != null) {
        texteDate = "Passé le ${date.day}/${date.month}/${date.year}";
      }

      enfants.add(
        Card(
          child: ListTile(
            leading: Icon(Icons.school),
            title: Text(r.matiere),
            subtitle: Text(texteDate),
            trailing: Text(
              "${r.score} / ${r.totalQuestions}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Mon profil"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              seDeconnecter();
            },
          ),
        ],
      ),
      body: ListView(padding: EdgeInsets.all(20), children: enfants),
    );
  }
}