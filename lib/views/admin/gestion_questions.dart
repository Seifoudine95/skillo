// vuede Story V: liste des questions d'une matière 
// boutons modif
// logique = question_service.dart

import 'package:flutter/services.dart'; // pour Clipboard (copier du texte)
import 'package:material_ui/material_ui.dart';
import 'package:skillo/models/question_model.dart';
import 'package:skillo/services/question_service.dart';
import 'package:skillo/views/admin/formulaire_question.dart';
import 'package:skillo/views/admin/importer_json.dart';

class GestionQuestions extends StatefulWidget {
  const GestionQuestions({super.key, required this.nomMatiere});
  final String nomMatiere;

  @override
  State<GestionQuestions> createState() => _GestionQuestionsState();
}

class _GestionQuestionsState extends State<GestionQuestions> {
  QuestionService service = QuestionService();

  List<QuestionQcm> questions = [];
  bool chargement = true;

  @override
  void initState() {
    super.initState();
    chargerQuestions();
  }

  Future<void> chargerQuestions() async {
    List<QuestionQcm> liste = await service.chargerQuestions(widget.nomMatiere);

    if (!mounted) {
      return;
    }

    setState(() {
      questions = liste;
      chargement = false;
    });
  }

  // ajouter une question :
  Future<void> ajouterQuestion() async {
    QuestionQcm nouvelle = QuestionQcm(
      id: "", //  vide 
      matiere: widget.nomMatiere,
      question: "",
      options: [],
      type: "radio",
      reponses: [],
      tempsLimite: 30,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormulaireQuestion(question: nouvelle),
      ),
    );
    chargerQuestions(); // on recharge quand on revient
  }

  // modifier une question : on envoie la question au formulaire
  Future<void> modifierQuestion(QuestionQcm question) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormulaireQuestion(question: question),
      ),
    );
    chargerQuestions();
  }

  Future<void> supprimerQuestion(QuestionQcm question) async {
    await service.supprimer(question.id);
    chargerQuestions();
  }

  // copie le JSON des questions
  Future<void> exporter() async {
    String texte = service.exporterJson(questions);
    await Clipboard.setData(ClipboardData(text: texte));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("JSON copié ! Tu peux le coller où tu veux.")),
    );
  }

  // ouvre la page pour importer un JSON
  Future<void> importer() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImporterJson(nomMatiere: widget.nomMatiere),
      ),
    );
    chargerQuestions();
  }

  @override
  Widget build(BuildContext context) {
    Widget contenu;

    if (chargement == true) {
      contenu = Center(child: CircularProgressIndicator());
    } else if (questions.isEmpty) {
      contenu = Center(child: Text("Aucune question pour cette matière"));
    } else {
      List<Widget> lignes = [];
      for (int i = 0; i < questions.length; i++) {
        QuestionQcm question = questions[i];

        String texteType = "Radio (une seule réponse)";
        if (question.type == "checkbox") {
          texteType = "Checkbox (plusieurs réponses)";
        }

        lignes.add(
          Card(
            child: ListTile(
              title: Text(question.question),
              subtitle: Text("$texteType - ${question.tempsLimite} secondes"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      modifierQuestion(question);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      supprimerQuestion(question);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
      contenu = ListView(padding: EdgeInsets.all(20), children: lignes);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Questions : ${widget.nomMatiere}"),
        actions: [
          TextButton(
            onPressed: () {
              exporter();
            },
            child: Text("Exporter"),
          ),
          TextButton(
            onPressed: () {
              importer();
            },
            child: Text("Importer"),
          ),
        ],
      ),
      body: contenu,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ajouterQuestion();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}