import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skillo/views/admin/tableau_de_bord_admin.dart';

void main() {
  testWidgets('dashboard shows results in date order', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TableauDeBordAdmin()));

    expect(find.text('Résultats récents'), findsOneWidget);
    expect(find.text('Amina Diallo'), findsOneWidget);
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
    await tester.pumpWidget(const MaterialApp(home: TableauDeBordAdmin()));

    await tester.enterText(find.byType(TextField), 'camille');
    await tester.pumpAndSettle();

    expect(find.text('Camille Bernard'), findsOneWidget);
    expect(find.text('Amina Diallo'), findsNothing);
  });

  testWidgets('school year filters results', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TableauDeBordAdmin()));

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('2025-2026').last);
    await tester.pumpAndSettle();

    expect(find.text('Camille Bernard'), findsOneWidget);
    expect(find.text('Amina Diallo'), findsNothing);
    expect(find.text('Yanis Morel'), findsNothing);
  });

  testWidgets('statistics page shows subject and overall indicators', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TableauDeBordAdmin()));
    await tester.tap(find.text('Statistiques'));
    await tester.pumpAndSettle();

    expect(find.text('Réussite par matière'), findsOneWidget);
    expect(find.text('HTML / CSS'), findsOneWidget);
    expect(find.text('Java'), findsOneWidget);
    expect(find.text('Algorithmique'), findsOneWidget);
    expect(find.text('Réussite générale'), findsOneWidget);
    expect(find.text('72 % de réussite'), findsOneWidget);
  });
}
