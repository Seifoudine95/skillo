// Story V: formulaire pour ajouter ou modifier une question 


import 'package:flutter/services.dart'; 
import 'package:material_ui/material_ui.dart';
import 'package:skillo/models/question_model.dart';
import 'package:skillo/services/question_service.dart';

class FormulaireQuestion extends StatefulWidget {
  const FormulaireQuestion({super.key, required this.question});

  // la question à modifier 
  final QuestionQcm question;

  @override
  State<FormulaireQuestion> createState() => _FormulaireQuestionState();
}

class _FormulaireQuestionState extends State<FormulaireQuestion> {
  QuestionService service = QuestionService();

  TextEditingController questionController = TextEditingController();
  TextEditingController tempsController = TextEditingController();

  // une case de texte par réponse proposée
  List<TextEditingController> optionsControllers = [];
  // pour chaque réponse : true si c'est une bonne réponse
  List<bool> bonnes = [];

  String type = "radio";
  String message = "";

  @override
  void initState() {
    super.initState();

    // on remplit le formulaire avec la question reçue
    questionController.text = widget.question.question;
    tempsController.text = widget.question.tempsLimite.toString();
    type = widget.question.type;

    for (int i = 0; i < widget.question.options.length; i++) {
      String option = widget.question.options[i];
      optionsControllers.add(TextEditingController(text: option));
      bonnes.add(widget.question.reponses.contains(option));
    }

    // nouvelle question : on met 2 réponses vides
    if (optionsControllers.isEmpty) {
      optionsControllers.add(TextEditingController());
      bonnes.add(false);
      optionsControllers.add(TextEditingController());
      bonnes.add(false);
    }
  }

  void ajouterOption() {
    setState(() {
      optionsControllers.add(TextEditingController());
      bonnes.add(false);
    });
  }

  void supprimerOption(int index) {
    if (optionsControllers.length <= 2) {
      setState(() {
        message = "Il faut au moins 2 réponses proposées";
      });
      return;
    }
    setState(() {
      optionsControllers.removeAt(index);
      bonnes.removeAt(index);
    });
  }

  // cocher ou décocher une bonne réponse
  void cocherReponse(int index) {
    setState(() {
      if (type == "radio") {
        // radio = unebonne réponse
        for (int i = 0; i < bonnes.length; i++) {
          bonnes[i] = false;
        }
        bonnes[index] = true;
      } else {
        // checkbox e
        bonnes[index] = !bonnes[index];
      }
    });
  }

  void changerType(String? nouveauType) {
    if (nouveauType == null) {
      return;
    }
    setState(() {
      type = nouveauType;
      for (int i = 0; i < bonnes.length; i++) {
        bonnes[i] = false;
      }
    });
  }

  Future<void> enregistrer() async {
    // récupère le texte de chaque réponse
    List<String> textes = [];
    for (int i = 0; i < optionsControllers.length; i++) {
      textes.add(optionsControllers[i].text);
    }

    String resultat = await service.enregistrer(
      widget.question.id,
      widget.question.matiere,
      questionController.text,
      type,
      tempsController.text,
      textes,
      bonnes,
    );

    if (!mounted) {
      return;
    }

    if (resultat == "") {
      Navigator.pop(context); // retour liste des questions
    } else {
      setState(() {
        message = resultat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String titre = "Modifier la question";
    if (widget.question.id == "") {
      titre = "Nouvelle question";
    }

    List<Widget> enfants = [];

    //  question
    enfants.add(
      TextField(
        controller: questionController,
        decoration: InputDecoration(
          labelText: "Question",
          border: OutlineInputBorder(),
        ),
      ),
    );
    enfants.add(SizedBox(height: 15));

    // type
    enfants.add(
      DropdownButton<String>(
        value: type,
        isExpanded: true,
        items: [
          DropdownMenuItem(
            value: "radio",
            child: Text("Radio (une seule bonne réponse)"),
          ),
          DropdownMenuItem(
            value: "checkbox",
            child: Text("Checkbox (plusieurs bonnes réponses)"),
          ),
        ],
        onChanged: (valeur) {
          changerType(valeur);
        },
      ),
    );
    enfants.add(SizedBox(height: 15));

    // temps limite
    enfants.add(
      TextField(
        controller: tempsController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: "Temps limite (en secondes)",
          border: OutlineInputBorder(),
        ),
      ),
    );
    enfants.add(SizedBox(height: 20));

    enfants.add(
      Text(
        "Réponses proposées (clique sur le rond ou le carré pour choisir la bonne réponse)",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    enfants.add(SizedBox(height: 10));

    // une ligne par réponse proposée
    for (int i = 0; i < optionsControllers.length; i++) {
      // carré =  checkbox et rond =  radio
      IconData icone;
      if (type == "checkbox") {
        if (bonnes[i] == true) {
          icone = Icons.check_box;
        } else {
          icone = Icons.check_box_outline_blank;
        }
      } else {
        if (bonnes[i] == true) {
          icone = Icons.radio_button_checked;
        } else {
          icone = Icons.radio_button_unchecked;
        }
      }

      enfants.add(
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              IconButton(
                icon: Icon(icone, color: Colors.green),
                onPressed: () {
                  cocherReponse(i);
                },
              ),
              Expanded(
                child: TextField(
                  controller: optionsControllers[i],
                  decoration: InputDecoration(
                    labelText: "Réponse ${i + 1}",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  supprimerOption(i);
                },
              ),
            ],
          ),
        ),
      );
    }

    enfants.add(
      TextButton(
        onPressed: () {
          ajouterOption();
        },
        child: Text("+ Ajouter une réponse"),
      ),
    );
    enfants.add(SizedBox(height: 20));
    enfants.add(
      ElevatedButton(
        onPressed: () {
          enregistrer();
        },
        child: Text("Enregistrer"),
      ),
    );
    enfants.add(SizedBox(height: 10));
    enfants.add(Text(message, style: TextStyle(color: Colors.red)));

    return Scaffold(
      appBar: AppBar(title: Text(titre)),
      body: ListView(padding: EdgeInsets.all(20), children: enfants),
    );
  }
}