import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';

class RechargeScreen extends StatelessWidget {
  const RechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      showBack: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Center(child: McWordmark(compact: false)),
            const SizedBox(height: 52),
            const Center(child: _RechargeTitle()),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Saldo actual',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
            const Center(
              child: Text(
                r'$45,00',
                style: TextStyle(
                  color: AppTheme.yellow,
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(height: 58),
            const Text(
              'Métodos de pago',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 22),
            const _PaymentMethodsBox(),
            const SizedBox(height: 24),
            const _RechargeAmountBox(),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(child: _AmountChip(label: r'$20')),
                SizedBox(width: 14),
                Expanded(child: _AmountChip(label: r'$50')),
                SizedBox(width: 14),
                Expanded(
                  flex: 2,
                  child: _AmountChip(label: r'$100', selected: true),
                ),
              ],
            ),
            const SizedBox(height: 42),
            DemoButton(
              label: 'CONFIRMAR RECARGA',
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.history);
              },
            ),
            const DemoBottomNav(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}

class _RechargeTitle extends StatelessWidget {
  const _RechargeTitle();

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            r'$',
            style: TextStyle(
              color: AppTheme.yellow,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'RECARGAR CUENTA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodsBox extends StatelessWidget {
  const _PaymentMethodsBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 28, 18, 26),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MethodItem(
              icon: Icons.credit_card_rounded,
              label: 'Tarjeta de\nCrédito/Débito',
              color: AppTheme.yellow,
            ),
          ),
          Expanded(
            child: _MethodItem(
              icon: Icons.account_balance_wallet_rounded,
              label: 'PayPal',
              color: Colors.white,
            ),
          ),
          Expanded(
            child: _MethodItem(
              icon: Icons.payments_rounded,
              label: 'Pago en Efectivo\n(Oxxo, 7-Eleven)',
              color: AppTheme.yellow,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodItem extends StatelessWidget {
  const _MethodItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 42),
        const SizedBox(height: 22),
        Text(
          '• $label',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            height: 1.18,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _RechargeAmountBox extends StatelessWidget {
  const _RechargeAmountBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF20201D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      alignment: Alignment.centerLeft,
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          r'Monto a recargar: $ [____]',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: selected ? AppTheme.yellow : const Color(0xFF20201D),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppTheme.black : AppTheme.yellow,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
