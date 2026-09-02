import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/auth/data/app_settings_api.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';
import 'package:mc_express/features/booking/data/service_requests_api.dart';

class ServicePaymentScreen extends StatefulWidget {
  const ServicePaymentScreen({super.key});

  @override
  State<ServicePaymentScreen> createState() => _ServicePaymentScreenState();
}

class _ServicePaymentScreenState extends State<ServicePaymentScreen> {
  final _api = ServiceRequestsApi();
  final _settingsApi = AppSettingsApi();
  final _notesController = TextEditingController();
  late final Future<AppSettings> _settingsFuture;
  String _selectedMethod = 'cash';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _settingsFuture = _settingsApi.publicSettings();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

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
            FutureBuilder<AppSettings>(
              future: _settingsFuture,
              builder: (context, snapshot) {
                final settings = snapshot.data;
                return _PaymentMethodPicker(
                  selectedMethod: _selectedMethod,
                  settings: settings,
                  onChanged: (method) =>
                      setState(() => _selectedMethod = method),
                );
              },
            ),
            const SizedBox(height: 34),
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
              child: TextField(
                controller: _notesController,
                maxLines: 4,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ej. pago aprobado, transferencia recibida...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            AppButton(
              label: 'PAGAR CON SALDO',
              outlined: true,
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.balancePayment, arguments: draft);
              },
            ),
            const SizedBox(height: 18),
            AppButton(
              label: _saving ? 'GUARDANDO...' : _buttonLabel(_selectedMethod),
              onPressed: () async {
                final navigator = Navigator.of(context);
                if (draft?.requestId != null) {
                  setState(() => _saving = true);
                  await _api.registerPayment(
                    requestId: draft!.requestId!,
                    amount: amount,
                    method: _selectedMethod,
                  );
                }
                if (!mounted) return;
                navigator.pushNamed(AppRoutes.rating, arguments: draft);
              },
            ),
            const SizedBox(height: 18),
            AppButton(
              label: 'REGRESAR AL TRABAJO',
              outlined: true,
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.tracking, arguments: draft);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _buttonLabel(String method) {
    return switch (method) {
      'card_credit' => 'COBRAR CON CRÉDITO',
      'card_debit' => 'COBRAR CON DÉBITO',
      'transfer' => 'REGISTRAR TRANSFERENCIA',
      'digital_wallet' => 'REGISTRAR BILLETERA',
      _ => 'PAGO RECIBIDO',
    };
  }
}

class _PaymentMethodPicker extends StatelessWidget {
  const _PaymentMethodPicker({
    required this.selectedMethod,
    required this.settings,
    required this.onChanged,
  });

  final String selectedMethod;
  final AppSettings? settings;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final methods = <_PaymentMethod>[
      if (settings?.cashPaymentsEnabled != false)
        const _PaymentMethod('cash', 'Efectivo', Icons.payments_rounded),
      if (settings?.transferPaymentsEnabled != false)
        const _PaymentMethod(
          'transfer',
          'Transferencia',
          Icons.account_balance_rounded,
        ),
      if (settings?.cardPaymentsEnabled != false) ...[
        const _PaymentMethod('card_debit', 'Débito', Icons.credit_card_rounded),
        const _PaymentMethod('card_credit', 'Crédito', Icons.add_card_rounded),
      ],
      const _PaymentMethod(
        'digital_wallet',
        'Billetera digital',
        Icons.wallet_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Método de cobro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: methods
              .map(
                (method) => ChoiceChip(
                  selected: selectedMethod == method.value,
                  onSelected: (_) => onChanged(method.value),
                  avatar: Icon(
                    method.icon,
                    size: 18,
                    color: selectedMethod == method.value
                        ? AppTheme.black
                        : AppTheme.yellow,
                  ),
                  label: Text(method.label),
                  selectedColor: AppTheme.yellow,
                  backgroundColor: const Color(0xFF171716),
                  labelStyle: TextStyle(
                    color: selectedMethod == method.value
                        ? AppTheme.black
                        : Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                  side: BorderSide(
                    color: selectedMethod == method.value
                        ? AppTheme.yellow
                        : Colors.white.withValues(alpha: 0.14),
                  ),
                ),
              )
              .toList(),
        ),
        if (selectedMethod.startsWith('card_')) ...[
          const SizedBox(height: 12),
          const Text(
            'El cobro con tarjeta queda registrado. Para cobrar automáticamente falta conectar la pasarela bancaria.',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}

class _PaymentMethod {
  const _PaymentMethod(this.value, this.label, this.icon);

  final String value;
  final String label;
  final IconData icon;
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
