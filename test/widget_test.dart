import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Shows the real home flow without bundled placeholder data', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());

    expect(find.text('Encuentra profesionales cerca de ti'), findsOneWidget);

    await tester.ensureVisible(find.text('Explorar servicios'));
    await tester.tap(find.text('Explorar servicios'));
    await tester.pumpAndSettle();

    expect(find.text('¿QUÉ SERVICIO'), findsOneWidget);
    expect(find.text('NECESITAS?'), findsOneWidget);
    expect(find.text('SOLICITAR SERVICIO'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('No se pudieron cargar las categorías.'), findsOneWidget);

    await tester.ensureVisible(find.text('SOLICITAR SERVICIO'));
    await tester.tap(find.text('SOLICITAR SERVICIO'));
    await tester.pumpAndSettle();

    expect(find.text('Profesionales cerca de ti'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('No se pudieron cargar profesionales.'), findsOneWidget);
  });

  testWidgets('Opens the quote request screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Explorar servicios'));
    await tester.tap(find.text('Explorar servicios'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('COTIZACION'));
    await tester.pumpAndSettle();

    expect(find.text('Solicitar cotización'), findsOneWidget);
    expect(find.text('BUSCAR PROFESIONAL'), findsOneWidget);
  });

  testWidgets('Keeps the wallet recharge flow available', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MC Express',
        theme: AppTheme.light,
        initialRoute: AppRoutes.recharge,
        routes: AppRoutes.routes,
      ),
    );

    expect(find.text('RECARGAR CUENTA'), findsOneWidget);
    expect(find.text('CONFIRMAR RECARGA'), findsOneWidget);
  });
}
