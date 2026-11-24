// VUE : connexion du candidat (story I)
// la logique = candidat_service.dart

import 'package:material_ui/material_ui.dart';
import 'package:skillo/services/candidat_service.dart';
import 'package:skillo/views/admin/connexion_admin.dart';
import 'package:skillo/views/utilisateur/accueil.dart';
import 'package:skillo/views/utilisateur/inscription.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  CandidatService service = CandidatService();

  TextEditingController nomController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  String message = ""; // message d'erreur affiché en rouge

  // quand on clique sur "Se connecter"
  Future<void> seConnecter() async {
    String resultat = await service.connexion(
      nomController.text.trim(),
      mailController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (resultat == "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Accueil()),
      );
    } else {
      setState(() {
        message = resultat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              "CONNEXION",
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
              controller: mailController,
              decoration: InputDecoration(
                labelText: "Mail",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                seConnecter();
              },
              child: Text("Se connecter"),
            ),
            SizedBox(height: 10),
            Text(message, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Inscription()),
                );
              },
              child: Text("Pas de compte ? S'inscrire"),
            ),
            // STORY IV : bouton pour aller à l'espace admin
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConnexionAdmin()),
                );
              },
              child: Text("Espace administrateur"),
            ),
          ],
        ),
      ),
    );
  }
}
