import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillo/models/matiere_model.dart';
import 'package:skillo/models/question_model.dart';
import 'package:skillo/models/resultat_candidat_model.dart';
import 'package:skillo/repository/matiere_repository.dart';
import 'package:skillo/repository/questionqcm_repository.dart';
import 'package:skillo/repository/tableau_de_bord_repository.dart';
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

final tableauDeBordRepositoryProvider = Provider<TableauDeBordRepository>((
  ref,
) {
  return TableauDeBordRepository();
});

final getResultatAdminProvider = StreamProvider<List<ResultatCandidat>>((ref) {
  return ref.watch(tableauDeBordRepositoryProvider).getResultats();
});

final userRepoitoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
