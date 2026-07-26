import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Navigates through the demo flow', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());

    expect(find.text('Encuentra profesionales cerca de ti'), findsOneWidget);

    await tester.ensureVisible(find.text('Continuar sin cuenta'));
    await tester.tap(find.text('Continuar sin cuenta'));
    await tester.pumpAndSettle();

    expect(find.text('¿QUÉ SERVICIO'), findsOneWidget);
    expect(find.text('NECESITAS?'), findsOneWidget);
    expect(find.text('Albañiles'), findsOneWidget);
    expect(find.text('SOLICITAR SERVICIO'), findsOneWidget);

    await tester.ensureVisible(find.text('SOLICITAR SERVICIO'));
    await tester.tap(find.text('SOLICITAR SERVICIO'));
    await tester.pumpAndSettle();

    expect(find.text('Profesionales cerca de ti'), findsOneWidget);

    await tester.ensureVisible(find.text('CONTINUAR CON CARLOS'));
    await tester.tap(find.text('CONTINUAR CON CARLOS'));
    await tester.pumpAndSettle();

    expect(find.text('Carlos M.'), findsWidgets);
    expect(find.text('SOLICITAR A CARLOS'), findsOneWidget);

    await tester.ensureVisible(find.text('SOLICITAR A CARLOS'));
    await tester.tap(find.text('SOLICITAR A CARLOS'));
    await tester.pumpAndSettle();

    expect(find.text('Confirma tu solicitud'), findsOneWidget);

    await tester.ensureVisible(find.text('ENVIAR SOLICITUD'));
    await tester.tap(find.text('ENVIAR SOLICITUD'));
    await tester.pumpAndSettle();

    expect(find.text('Crear cuenta'), findsOneWidget);
  });

  testWidgets('Opens the quote request screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Continuar sin cuenta'));
    await tester.tap(find.text('Continuar sin cuenta'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('COTIZACION'));
    await tester.pumpAndSettle();

    expect(find.text('Solicitar cotización'), findsOneWidget);
    expect(find.text('ENVIAR COTIZACIÓN'), findsOneWidget);
  });

  testWidgets('Keeps the wallet payment flow available', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MC Express',
        theme: AppTheme.light,
        initialRoute: AppRoutes.servicePayment,
        routes: AppRoutes.routes,
      ),
    );

    expect(find.text('PAGO DEL SERVICIO'), findsOneWidget);

    await tester.ensureVisible(find.text('PAGAR CON SALDO'));
    await tester.tap(find.text('PAGAR CON SALDO'));
    await tester.pumpAndSettle();

    expect(find.text('PAGO CON\nSALDO DE CUENTA'), findsOneWidget);

    await tester.ensureVisible(find.text('CONFIRMAR PAGO'));
    await tester.tap(find.text('CONFIRMAR PAGO'));
    await tester.pumpAndSettle();

    expect(find.text('RECARGAR CUENTA'), findsOneWidget);
  });
}
