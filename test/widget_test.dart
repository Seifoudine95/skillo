import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skillo/views/admin/tableau_de_bord_admin.dart';

void main() {
  testWidgets('dashboard page shows sample results and filters', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TableauDeBordAdmin()));

    expect(find.text('Résultats récents'), findsOneWidget);
    expect(find.text('Amina Diallo'), findsOneWidget);
    expect(find.text('Yanis Morel'), findsOneWidget);
    expect(find.text('Rechercher par nom ou prénom'), findsOneWidget);
    expect(find.text('Année scolaire'), findsOneWidget);
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
