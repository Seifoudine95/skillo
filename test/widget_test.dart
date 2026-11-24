import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skillo/models/resultat_candidat_model.dart';
import 'package:skillo/providers/providers.dart';
import 'package:skillo/repository/tableau_de_bord_repository.dart';
import 'package:skillo/views/admin/tableau_de_bord_admin.dart';

void main() {
  testWidgets('dashboard shows results in date order', (
    WidgetTester tester,
  ) async {
    await _pumpDashboard(tester);

    expect(find.text('Résultats récents'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Ami Diallo'),
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('dashboardList')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Ami Diallo'), findsOneWidget);
    expect(find.text('Yanis Morel'), findsOneWidget);
    expect(find.text('Rechercher par nom ou prénom'), findsOneWidget);
    expect(find.text('Année scolaire'), findsOneWidget);
    expect(
      find.text('HTML / CSS · 8/10\n20/11/2026 · 2026-2027'),
      findsOneWidget,
    );
    expect(
      find.text('Algorithmique · 9/10\n08/04/2026 · 2025-2026'),
      findsOneWidget,
    );
  });

  testWidgets('search filters candidates by first or last name', (
    WidgetTester tester,
  ) async {
    await _pumpDashboard(tester);

    await tester.enterText(find.byType(TextField), 'camille');
    await tester.pumpAndSettle();

    expect(find.text('Camille Bernard'), findsOneWidget);
    expect(find.text('Amina Diallo'), findsNothing);
  });

  testWidgets('school year filters results', (WidgetTester tester) async {
    await _pumpDashboard(tester);

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('2025-2026').last);
    await tester.pumpAndSettle();

    expect(find.text('Camille Bernard'), findsOneWidget);
    expect(find.text('Amina Diallo'), findsNothing);
    expect(find.text('Yanis Morel'), findsNothing);
  });

  testWidgets('statistics page calculates success rates from results', (
    WidgetTester tester,
  ) async {
    await _pumpDashboard(tester);
    await tester.tap(find.text('Statistiques'));
    await tester.pumpAndSettle();

    expect(find.text('Réussite par matière'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('67 % de réussite'),
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('statisticsList')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Réussite générale'), findsOneWidget);
    expect(find.text('67 % de réussite'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Java'),
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('statisticsList')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('0 % · 0 réussite(s) sur 1 résultat(s)'), findsOneWidget);
  });

  testWidgets('statistics are filtered by school year', (
    WidgetTester tester,
  ) async {
    await _pumpDashboard(tester);
    await tester.tap(find.text('Statistiques'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('2026-2027').last);
    await tester.pumpAndSettle();

    expect(find.text('50 % de réussite'), findsOneWidget);
    expect(find.text('Algorithmique'), findsNothing);
    expect(find.text('HTML / CSS'), findsOneWidget);
  });
}

Future<void> _pumpDashboard(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        tableauDeBordRepositoryProvider.overrideWithValue(_TestRepository()),
      ],
      child: const MaterialApp(home: TableauDeBordAdmin()),
    ),
  );
  await tester.pumpAndSettle();
}

class _TestRepository extends TableauDeBordRepository {
  @override
  Stream<List<ResultatCandidat>> getResultats() {
    return Stream.value([
      ResultatCandidat(
        prenom: 'Ami',
        nom: 'Diallo',
        matiere: 'HTML / CSS',
        score: 8,
        totalQuestions: 10,
        date: DateTime(2026, 11, 20),
      ),
      ResultatCandidat(
        prenom: 'Yanis',
        nom: 'Morel',
        matiere: 'Java',
        score: 4,
        totalQuestions: 10,
        date: DateTime(2026, 11, 18),
      ),
      ResultatCandidat(
        prenom: 'Camille',
        nom: 'Bernard',
        matiere: 'Algorithmique',
        score: 9,
        totalQuestions: 10,
        date: DateTime(2026, 4, 8),
      ),
    ]);
  }
}
