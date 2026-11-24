// VUE : score story II

import 'package:material_ui/material_ui.dart';
import 'package:skillo/views/utilisateur/accueil.dart';

class FinTest extends StatelessWidget {
  const FinTest({super.key, required this.score, required this.total});

  final int score; // nombre de bonnes réponses
  final int total; // nombre de questions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Test terminé !",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Ton score : $score / $total", style: TextStyle(fontSize: 24)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // retour accueil 
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Accueil()),
                  (route) => false,
                );
              },
              child: Text("Retour à l'accueil"),
            ),
          ],
        ),
      ),
    );
  }
}