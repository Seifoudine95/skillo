// VUE : story IV
// la logique de admin_service.dart

import 'package:material_ui/material_ui.dart';
import 'package:skillo/services/admin_service.dart';

class AjouterMatiere extends StatefulWidget {
  const AjouterMatiere({super.key});

  @override
  State<AjouterMatiere> createState() => _AjouterMatiereState();
}

class _AjouterMatiereState extends State<AjouterMatiere> {
  AdminService service = AdminService();

  TextEditingController nomController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String message = "";

  Future<void> ajouter() async {
    String resultat = await service.ajouterMatiere(
      nomController.text.trim(),
      descriptionController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (resultat == "") {
      Navigator.pop(context); 
    } else {
      setState(() {
        message = resultat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une matière")),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: "Nom de la matière",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ajouter();
              },
              child: Text("Ajouter"),
            ),
            SizedBox(height: 10),
            Text(message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}