// VUE : story IV connexion de l'administrateur 
// la logique deadmin_service.dart

import 'package:material_ui/material_ui.dart';
import 'package:skillo/services/admin_service.dart';
import 'package:skillo/views/admin/acueil_admin.dart';

class ConnexionAdmin extends StatefulWidget {
  const ConnexionAdmin({super.key});

  @override
  State<ConnexionAdmin> createState() => _ConnexionAdminState();
}

class _ConnexionAdminState extends State<ConnexionAdmin> {
  AdminService service = AdminService();

  TextEditingController emailController = TextEditingController();
  TextEditingController mdpController = TextEditingController();

  String message = "";

  Future<void> seConnecter() async {
    String resultat = await service.connexion(
      emailController.text.trim(),
      mdpController.text,
    );

    if (!mounted) {
      return;
    }

    if (resultat == "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AcueilAdmin()),
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
      appBar: AppBar(title: Text("Espace administrateur")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              "CONNEXION ADMIN",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: mdpController,
              obscureText: true, // cache le mot de passe avec des points
              decoration: InputDecoration(
                labelText: "Mot de passe",
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
          ],
        ),
      ),
    );
  }
}