import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skillo/providers/providers.dart';
import 'package:skillo/views/utilisateur/accueil.dart';

class PageQsm extends ConsumerStatefulWidget {
  const PageQsm({super.key, required this.nomMat});
  final String nomMat;

  @override
  ConsumerState<PageQsm> createState() => _PageQsmState();
}

class _PageQsmState extends ConsumerState<PageQsm> {
  late String coure = widget.nomMat;

  Duration _minute = Duration(seconds: 5);

  late Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() {
      if (_minute.inSeconds > 0) {
        _minute = _minute - Duration(seconds: 1);
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return dialogueTemps(context);
          },
        );
        timer.cancel();
      }
    });
  });

  int courante = 0;
  int selection = 0;
  bool isV = false;

  @override
  void initState() {
    super.initState();
    timer;
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = ref.watch(getQuestionProvider(coure));
    return Scaffold(
      body: question.when(
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        loading: () => Center(child: CircularProgressIndicator()),
        data: (questions) {
          if (questions.isEmpty) {
            timer.cancel();
            return Center(child: Text("Pas de donnée"));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Question ${courante + 1} sur ${questions.length}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Temps restant : 00:${(_minute.inSeconds)}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.2,
                    vertical: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          questions[courante].question,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ...List.generate(questions[courante].options.length, (
                          index,
                        ) {
                          String qsm = questions[courante].options[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: RadioGroup(
                              groupValue: isV == false ? null : selection,
                              onChanged: (value) {
                                setState(() {
                                  selection = value!;
                                  isV = true;
                                  // reponse = qsm;
                                  // notes(reponse);
                                });
                              },
                              child: RadioListTile(
                                value: index,
                                title: Text(qsm),
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (courante < questions.length - 1) {
                                courante++;
                                _minute = Duration(seconds: 5);
                                isV = false;
                              } else {
                                timer.cancel();
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return dialogue(context);
                                  },
                                );
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Suivant",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget dialogue(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    title: Text("Merci !"),
    content: Text("Vous avez terminé le QSM !"),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Accueil()),
            (route) => false,
          );
        },
        child: Text("OK"),
      ),
    ],
  );
}

Widget dialogueTemps(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    title: Text("Temps écoulé !"),
    content: Text("Le temps imparti pour le QSM est écoulé."),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Accueil()),
            (route) => false,
          );
        },
        child: Text("OK"),
      ),
    ],
  );
}
