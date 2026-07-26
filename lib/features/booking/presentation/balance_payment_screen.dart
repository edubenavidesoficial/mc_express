import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';

class BalancePaymentScreen extends StatelessWidget {
  const BalancePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      showBack: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const McWordmark(compact: true),
            const SizedBox(height: 44),
            const _Title(),
            const SizedBox(height: 28),
            Text(
              'Saldo disponible',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              r'$45,00',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 46),
            const _ServiceDetail(),
            const SizedBox(height: 34),
            const _DiscountNote(),
            const SizedBox(height: 42),
            DemoButton(
              label: 'CONFIRMAR PAGO',
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.recharge);
              },
            ),
            const SizedBox(height: 18),
            DemoButton(
              label: 'VOLVER',
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.yellow,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.speed_rounded, color: AppTheme.yellow, size: 34),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            'PAGO CON\nSALDO DE CUENTA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.yellow,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceDetail extends StatelessWidget {
  const _ServiceDetail();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.speed_rounded, color: AppTheme.yellow, size: 26),
            SizedBox(width: 8),
            Text(
              'Detalle del servicio',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        SizedBox(height: 22),
        _DetailLine(label: 'Monto total:', value: r'$28,00'),
        SizedBox(height: 16),
        _DetailLine(label: 'Comisión plataforma', value: r'15%: $4,20'),
        SizedBox(height: 16),
        _DetailLine(label: 'Total a descontar:', value: r'$28,00'),
        SizedBox(height: 22),
        Divider(color: Color(0xFF494949)),
      ],
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '•',
          style: TextStyle(color: Colors.white, fontSize: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _DiscountNote extends StatelessWidget {
  const _DiscountNote();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline_rounded, color: AppTheme.yellow, size: 18),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            'Al confirmar se descuenta\nautomáticamente de tu saldo',
            style: TextStyle(
              color: AppTheme.yellow,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}
