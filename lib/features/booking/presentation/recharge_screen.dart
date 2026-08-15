import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_requests_api.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final _api = ServiceRequestsApi();
  late Future<double> _balanceFuture;
  double _amount = 20;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _balanceFuture = _api.walletBalance();
  }

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
            Center(
              child: FutureBuilder<double>(
                future: _balanceFuture,
                builder: (context, snapshot) {
                  final balance = snapshot.data ?? 0;
                  return Text(
                    '\$${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.yellow,
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  );
                },
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
            _RechargeAmountBox(amount: _amount),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _AmountChip(
                    amount: 20,
                    selected: _amount == 20,
                    onTap: _selectAmount,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _AmountChip(
                    amount: 50,
                    selected: _amount == 50,
                    onTap: _selectAmount,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 2,
                  child: _AmountChip(
                    amount: 100,
                    selected: _amount == 100,
                    onTap: _selectAmount,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 42),
            AppButton(
              label: _saving ? 'GUARDANDO...' : 'CONFIRMAR RECARGA',
              onPressed: () async {
                final navigator = Navigator.of(context);
                setState(() => _saving = true);
                await _api.rechargeWallet(_amount);
                if (!mounted) return;
                navigator.pushNamed(AppRoutes.history);
              },
            ),
            const AppBottomNav(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  void _selectAmount(double value) {
    setState(() => _amount = value);
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
  const _RechargeAmountBox({required this.amount});

  final double amount;

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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'Monto a recargar: \$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
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
  const _AmountChip({
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  final double amount;
  final bool selected;
  final ValueChanged<double> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(amount),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: selected ? AppTheme.yellow : const Color(0xFF20201D),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          '\$${amount.toStringAsFixed(0)}',
          style: TextStyle(
            color: selected ? AppTheme.black : AppTheme.yellow,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
