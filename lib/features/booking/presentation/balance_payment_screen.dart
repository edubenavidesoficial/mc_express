import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';
import 'package:mc_express/features/booking/data/service_requests_api.dart';

class BalancePaymentScreen extends StatefulWidget {
  const BalancePaymentScreen({super.key});

  @override
  State<BalancePaymentScreen> createState() => _BalancePaymentScreenState();
}

class _BalancePaymentScreenState extends State<BalancePaymentScreen> {
  final _api = ServiceRequestsApi();
  late Future<double> _balanceFuture;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _balanceFuture = _api.walletBalance();
  }

  @override
  Widget build(BuildContext context) {
    final draft =
        ModalRoute.of(context)?.settings.arguments as ServiceRequestDraft?;
    final amount = draft?.estimatedPrice ?? 0;
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
            FutureBuilder<double>(
              future: _balanceFuture,
              builder: (context, snapshot) {
                final balance = snapshot.data ?? 0;
                return Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                );
              },
            ),
            const SizedBox(height: 46),
            _ServiceDetail(amount: amount),
            const SizedBox(height: 34),
            const _DiscountNote(),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Color(0xFFFF5A52))),
            ],
            const SizedBox(height: 42),
            AppButton(
              label: _saving ? 'PAGANDO...' : 'CONFIRMAR PAGO',
              onPressed: () async {
                if (draft?.requestId == null) return;
                final navigator = Navigator.of(context);
                setState(() {
                  _saving = true;
                  _error = null;
                });
                try {
                  await _api.payWithWallet(
                    requestId: draft!.requestId!,
                    amount: amount,
                  );
                  if (!mounted) return;
                  navigator.pushNamed(
                    AppRoutes.rating,
                    arguments: draft,
                  );
                } catch (_) {
                  setState(() => _error = 'Saldo insuficiente. Recarga tu cuenta.');
                } finally {
                  if (mounted) setState(() => _saving = false);
                }
              },
            ),
            const SizedBox(height: 18),
            AppButton(
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
  const _ServiceDetail({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
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
        const SizedBox(height: 22),
        _DetailLine(label: 'Monto total:', value: '\$${amount.toStringAsFixed(2)}'),
        const SizedBox(height: 16),
        const _DetailLine(label: 'Método:', value: 'Saldo'),
        const SizedBox(height: 16),
        _DetailLine(label: 'Total a descontar:', value: '\$${amount.toStringAsFixed(2)}'),
        const SizedBox(height: 22),
        const Divider(color: Color(0xFF494949)),
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
