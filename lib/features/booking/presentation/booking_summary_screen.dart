import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/storage/session_store.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_requests_api.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final _serviceRequestsApi = ServiceRequestsApi();
  bool _isSaving = false;
  String? _error;

  Future<void> _sendRequest() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      final isLoggedIn = await SessionStore.instance.isLoggedIn;
      if (!isLoggedIn && mounted) {
        Navigator.of(context).pushNamed(AppRoutes.auth);
        return;
      }
      await _serviceRequestsApi.createPlumbingRequest();
      if (!mounted) return;
      Navigator.of(context).pushNamed(AppRoutes.bookingSuccess);
    } catch (_) {
      setState(() => _error = 'No se pudo guardar la solicitud');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Center(child: McWordmark(compact: true)),
            const SizedBox(height: 34),
            const Text(
              'Confirma tu solicitud',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                height: 1,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa los datos antes de enviar el servicio.',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 24),
            const _SummaryCard(),
            const SizedBox(height: 18),
            const _NotesBox(),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(
                _error!,
                style: const TextStyle(
                  color: Color(0xFFFF5A52),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            const SizedBox(height: 24),
            DemoButton(
              label: _isSaving ? 'GUARDANDO...' : 'ENVIAR SOLICITUD',
              onPressed: _isSaving ? () {} : _sendRequest,
            ),
            const SizedBox(height: 14),
            DemoButton(
              label: 'CAMBIAR PROFESIONAL',
              outlined: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.yellow.withValues(alpha: 0.45)),
      ),
      child: const Column(
        children: [
          _SummaryRow(
            icon: Icons.plumbing_rounded,
            label: 'Servicio',
            value: 'Plomería',
          ),
          Divider(color: Color(0xFF383838), height: 28),
          _SummaryRow(
            icon: Icons.person_rounded,
            label: 'Profesional',
            value: 'Carlos M. · 4.9',
          ),
          Divider(color: Color(0xFF383838), height: 28),
          _SummaryRow(
            icon: Icons.location_on_rounded,
            label: 'Ubicación',
            value: 'A 1.2 km de tu punto',
          ),
          Divider(color: Color(0xFF383838), height: 28),
          _SummaryRow(
            icon: Icons.schedule_rounded,
            label: 'Llegada estimada',
            value: '8 min',
          ),
          Divider(color: Color(0xFF383838), height: 28),
          _SummaryRow(
            icon: Icons.payments_rounded,
            label: 'Valor estimado',
            value: r'$28,00',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.yellow, size: 28),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: highlight ? AppTheme.yellow : Colors.white,
                  fontSize: highlight ? 24 : 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotesBox extends StatelessWidget {
  const _NotesBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF22221F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalle para el profesional',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Fuga debajo del lavamanos. Requiere revisión de tubería y llave de paso.',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.35,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
