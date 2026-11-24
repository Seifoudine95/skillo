import 'package:flutter_test/flutter_test.dart';
import 'package:skillo/services/question_service.dart';

void main() {
  test('Un JSON correct est importé', () {
    final resultat = lireJson('''
      [
        {"question": "2 + 2 ?", "type": "radio", "options": ["3", "4"], "reponses": ["4"], "tempsLimite": 20},
        {"question": "Nombres pairs ?", "type": "checkbox", "options": ["1", "2", "4"], "reponses": ["2", "4"]}
      ]
    ''', 'Maths');

    expect(resultat.erreur, "");
    expect(resultat.questions.length, 2);
    expect(resultat.questions[0].matiere, 'Maths');
    expect(resultat.questions[0].tempsLimite, 20);
    expect(resultat.questions[1].tempsLimite, 30); // valeur par défaut
  });

  test('Un texte qui n\'est pas du JSON donne une erreur', () {
    expect(lireJson('pas du json', 'Maths').erreur, isNot(""));
  });

  test('Une question radio avec 2 bonnes réponses est refusée', () {
    final resultat = lireJson(
      '[{"question": "?", "type": "radio", "options": ["a", "b"], "reponses": ["a", "b"]}]',
      'Maths',
    );
    expect(resultat.erreur, contains('Question 1'));
  });

  test('Une bonne réponse absente des options est refusée', () {
    final resultat = lireJson(
      '[{"question": "?", "options": ["a", "b"], "reponses": ["c"]}]',
      'Maths',
    );
    expect(resultat.erreur, isNot(""));
  });
}
