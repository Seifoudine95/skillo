// VUE :  test story II
// la logique = test_service.dart
// chrono 

import 'dart:async'; // chrono
import 'package:material_ui/material_ui.dart';
import 'package:skillo/models/question_model.dart';
import 'package:skillo/services/test_service.dart';
import 'package:skillo/views/utilisateur/fin_test.dart';

class PageQsm extends StatefulWidget {
  const PageQsm({super.key, required this.nomMat});
  final String nomMat; //  matière choisie

  @override
  State<PageQsm> createState() => _PageQsmState();
}

class _PageQsmState extends State<PageQsm> {
  TestService service = TestService();

  List<QuestionQcm> questions = [];
  bool chargement = true;
  int courante = 0; // numéro question affichée 
  List<String> choix = []; // les réponses cochées par le candidat
  int score = 0;
  int tempsRestant = 0;
  Timer? chrono; // chrono n'est pas lancé rien
  bool fini = false;

  @override
  void initState() {
    super.initState();
    chargerQuestions();
  }

  // quitter la page = arret du chrono
  @override
  void dispose() {
    arreterChrono();
    super.dispose();
  }

  Future<void> chargerQuestions() async {
    List<QuestionQcm> liste = await service.chargerQuestions(widget.nomMat);

    if (!mounted) {
      return;
    }

    setState(() {
      questions = liste;
      chargement = false;
    });

    if (questions.isNotEmpty) {
      lancerChrono();
    }
  }

  void arreterChrono() {
    if (chrono != null) {
      chrono!.cancel(); //  ! : chrno allumé
    }
  }

  // chaque question a son propre temps limite
  void lancerChrono() {
    arreterChrono();
    tempsRestant = questions[courante].tempsLimite;

    // toutes les secondes  enlève 1 au temps restant
    chrono = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() {
        tempsRestant = tempsRestant - 1;
      });
      // temps écoulé = prochaine question
      if (tempsRestant <= 0) {
        questionSuivante();
      }
    });
  }

  void cliquerReponse(String option) {
    List<String> nouveauChoix = service.choisirReponse(
      choix,
      option,
      questions[courante].type,
    );
    setState(() {
      choix = nouveauChoix;
    });
  }

  void questionSuivante() {
    if (fini == true) {
      return;
    }

    // un point = bonne réponse 
    if (service.estBonneReponse(choix, questions[courante].reponses)) {
      score = score + 1;
    }

    if (courante < questions.length - 1) {
      // reste des questions
      setState(() {
        courante = courante + 1;
        choix = [];
      });
      lancerChrono();
    } else {
      // dernière question
      fini = true;
      arreterChrono();
      terminerTest();
    }
  }

  // enregistre le résultat et affiche le score
  Future<void> terminerTest() async {
    await service.enregistrerResultat(widget.nomMat, score, questions.length);

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FinTest(score: score, total: questions.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // pendant le chargement
    if (chargement == true) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    //  pas de question
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.nomMat)),
        body: Center(child: Text("Pas de question pour cette matière")),
      );
    }

    QuestionQcm question = questions[courante];

    String aide = "Une seule réponse possible";
    if (question.type == "checkbox") {
      aide = "Plusieurs réponses possibles";
    }

    // on construit la liste de ce qu'on affiche
    List<Widget> enfants = [];

    enfants.add(
      Text(
        question.question,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
    enfants.add(SizedBox(height: 10));
    enfants.add(Text(aide, textAlign: TextAlign.center));
    enfants.add(SizedBox(height: 20));

    // une ligne par réponse proposée
    for (int i = 0; i < question.options.length; i++) {
      String option = question.options[i];

      // carré = checkbox 
      //rond = radio
      IconData icone;
      if (question.type == "checkbox") {
        if (choix.contains(option)) {
          icone = Icons.check_box;
        } else {
          icone = Icons.check_box_outline_blank;
        }
      } else {
        if (choix.contains(option)) {
          icone = Icons.radio_button_checked;
        } else {
          icone = Icons.radio_button_unchecked;
        }
      }

      enfants.add(
        ListTile(
          leading: Icon(icone, color: Colors.blue),
          title: Text(option),
          onTap: () {
            cliquerReponse(option);
          },
        ),
      );
    }

    enfants.add(SizedBox(height: 20));
    enfants.add(
      ElevatedButton(
        onPressed: () {
          questionSuivante();
        },
        child: Text("Suivant"),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Question ${courante + 1} sur ${questions.length}   -   Temps restant : $tempsRestant s",
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // pas de bouton retour pendant le test
      ),
      body: ListView(padding: EdgeInsets.all(20), children: enfants),
    );
  }
}