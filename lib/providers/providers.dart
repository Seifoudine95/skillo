import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:skillo/models/matiere_model.dart';
import 'package:skillo/models/question_model.dart';
import 'package:skillo/repository/matiere_repository.dart';
import 'package:skillo/repository/questionqcm_repository.dart';
import 'package:skillo/repository/resultat_repository.dart';
import 'package:skillo/repository/user_repository.dart';

final matiereRepositoryProvider = Provider<MatiereRepository>((ref) {
  return MatiereRepository();
});

final getMatiereProvider = StreamProvider<List<Matiere>>((ref) {
  return ref.watch(matiereRepositoryProvider).getMatiere();
});

final questionRepositoryProvider = Provider<QuestionQcmRepository>((ref) {
  return QuestionQcmRepository();
});

final getQuestionProvider = StreamProvider.family<List<QuestionQcm>, String>((
  ref,
  matiere,
) {
  return ref.watch(questionRepositoryProvider).getQuestion(matiere);
});

final userProvider = ChangeNotifierProvider<UserRepository>((ref) {
  return UserRepository();
});

final resultatProvider = ChangeNotifierProvider<ResultatRepository>((ref) {
  return ResultatRepository();
});
