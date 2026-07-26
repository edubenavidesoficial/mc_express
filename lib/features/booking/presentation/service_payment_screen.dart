import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';

class ServicePaymentScreen extends StatelessWidget {
  const ServicePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'MC',
              style: TextStyle(
                color: AppTheme.yellow,
                fontSize: 58,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 54),
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'PAGO DEL SERVICIO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(height: 36),
            const _AmountLine(),
            const SizedBox(height: 30),
            const Text(
              'Formas de pago: Efectivo, Transferencia\nbancaria, Billeteras digitales',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.25,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 70),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Observaciones sobre el pago',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 130,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF22221F),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.topLeft,
              child: Text(
                'Observaciones sobre el pago',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(height: 26),
            DemoButton(
              label: 'PAGAR CON SALDO',
              outlined: true,
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.balancePayment);
              },
            ),
            const SizedBox(height: 18),
            DemoButton(
              label: 'PAGO RECIBIDO',
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.rating);
              },
            ),
            const SizedBox(height: 18),
            DemoButton(
              label: 'REGRESAR AL TRABAJO',
              outlined: true,
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.tracking);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountLine extends StatelessWidget {
  const _AmountLine();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          children: [
            TextSpan(text: 'Monto total: '),
            TextSpan(
              text: r'$28,00',
              style: TextStyle(
                color: AppTheme.yellow,
                fontSize: 54,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
