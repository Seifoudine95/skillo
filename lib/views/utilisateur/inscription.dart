// VUE : inscription du candidat story I
// logique = candidat_service.dart

import 'package:material_ui/material_ui.dart';
import 'package:skillo/services/candidat_service.dart';
import 'package:skillo/views/utilisateur/accueil.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  CandidatService service = CandidatService();

  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController adresseController = TextEditingController();

  String? motivation; //  rien n'est choisi
  String message = "";

  // clique sur "S'inscrire"
  Future<void> sInscrire() async {
    String resultat = await service.inscrire(
      nomController.text.trim(),
      prenomController.text.trim(),
      mailController.text.trim(),
      ageController.text.trim(),
      adresseController.text.trim(),
      motivation,
    );

    if (!mounted) {
      return;
    }

    if (resultat == "") {
      // inscription réussie 
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Accueil()),
        (route) => false,
      );
    } else {
      setState(() {
        message = resultat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // crée la liste des  motivations
    List<DropdownMenuItem<String>> choix = [];
    for (int i = 0; i < service.motivations.length; i++) {
      choix.add(
        DropdownMenuItem(
          value: service.motivations[i],
          child: Text(service.motivations[i]),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              "INSCRIPTION",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: "Nom",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: prenomController,
              decoration: InputDecoration(
                labelText: "Prénom",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: mailController,
              decoration: InputDecoration(
                labelText: "Mail",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Âge",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: adresseController,
              decoration: InputDecoration(
                labelText: "Adresse postale",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sInscrire();
              },
              child: Text("S'inscrire"),
            ),
            SizedBox(height: 10),
            Text(message, style: TextStyle(color: Colors.red)),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Déjà un compte ? Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}