// VUE : page pour réinitialiser une matière avec un JSON (story V)


import 'package:material_ui/material_ui.dart';
import 'package:skillo/services/question_service.dart';

class ImporterJson extends StatefulWidget {
  const ImporterJson({super.key, required this.nomMatiere});
  final String nomMatiere;

  @override
  State<ImporterJson> createState() => _ImporterJsonState();
}

class _ImporterJsonState extends State<ImporterJson> {
  QuestionService service = QuestionService();

  TextEditingController jsonController = TextEditingController();
  String message = "";

  // exemple  pour aider l'admin
  String exemple =
      '[{"question": "2 + 2 = ?", "options": ["3", "4"], "type": "radio", "reponses": ["4"], "tempsLimite": 20}]';

  Future<void> importer() async {
    String resultat = await service.importerJson(
      jsonController.text,
      widget.nomMatiere,
    );

    if (!mounted) {
      return;
    }

    if (resultat == "") {
      Navigator.pop(context); // retour à la liste des questions
    } else {
      setState(() {
        message = resultat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Importer un JSON : ${widget.nomMatiere}")),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            "Attention : toutes les questions de ${widget.nomMatiere} vont être remplacées.",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text("Exemple :"),
          SelectableText(exemple),
          SizedBox(height: 20),
          TextField(
            controller: jsonController,
            maxLines: 12,
            decoration: InputDecoration(
              hintText: "Colle le JSON ici",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              importer();
            },
            child: Text("Importer"),
          ),
          SizedBox(height: 10),
          Text(message, style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}