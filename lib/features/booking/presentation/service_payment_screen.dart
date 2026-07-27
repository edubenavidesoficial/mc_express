import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';
import 'package:mc_express/features/booking/data/service_requests_api.dart';

class ServicePaymentScreen extends StatefulWidget {
  const ServicePaymentScreen({super.key});

  @override
  State<ServicePaymentScreen> createState() => _ServicePaymentScreenState();
}

class _ServicePaymentScreenState extends State<ServicePaymentScreen> {
  final _api = ServiceRequestsApi();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final draft =
        ModalRoute.of(context)?.settings.arguments as ServiceRequestDraft?;
    final amount = draft?.estimatedPrice ?? 0;
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
            _AmountLine(amount: amount),
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
            AppButton(
              label: 'PAGAR CON SALDO',
              outlined: true,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.balancePayment,
                  arguments: draft,
                );
              },
            ),
            const SizedBox(height: 18),
            AppButton(
              label: _saving ? 'GUARDANDO...' : 'PAGO RECIBIDO',
              onPressed: () async {
                final navigator = Navigator.of(context);
                if (draft?.requestId != null) {
                  setState(() => _saving = true);
                  await _api.registerPayment(
                    requestId: draft!.requestId!,
                    amount: amount,
                    method: 'cash',
                  );
                }
                if (!mounted) return;
                navigator.pushNamed(
                  AppRoutes.rating,
                  arguments: draft,
                );
              },
            ),
            const SizedBox(height: 18),
            AppButton(
              label: 'REGRESAR AL TRABAJO',
              outlined: true,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.tracking,
                  arguments: draft,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountLine extends StatelessWidget {
  const _AmountLine({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          children: [
            const TextSpan(text: 'Monto total: '),
            TextSpan(
              text: '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
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
