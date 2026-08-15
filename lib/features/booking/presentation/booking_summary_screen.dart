import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/storage/session_store.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';
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

  Future<void> _sendRequest(ServiceRequestDraft draft) async {
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
      final requestId = await _serviceRequestsApi.createRequest(draft);
      if (!mounted) return;
      Navigator.of(context).pushNamed(
        AppRoutes.serviceOffers,
        arguments: draft.copyWith(requestId: requestId),
      );
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
    final draft =
        ModalRoute.of(context)?.settings.arguments as ServiceRequestDraft?;

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
            if (draft == null)
              const _MissingDraftCard()
            else
              _SummaryCard(draft: draft),
            const SizedBox(height: 18),
            _NotesBox(
              description:
                  draft?.description ??
                  'Solicitud de ${draft?.categoryName ?? 'servicio'} creada desde la app.',
            ),
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
            AppButton(
              label: _isSaving ? 'GUARDANDO...' : 'ENVIAR SOLICITUD',
              onPressed: _isSaving || draft == null
                  ? () {}
                  : () => _sendRequest(draft),
            ),
            const SizedBox(height: 14),
            AppButton(
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
  const _SummaryCard({required this.draft});

  final ServiceRequestDraft draft;

  @override
  Widget build(BuildContext context) {
    final price = draft.estimatedPrice == null
        ? 'Por cotizar'
        : '\$${draft.estimatedPrice!.toStringAsFixed(2)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.yellow.withValues(alpha: 0.45)),
      ),
      child: Column(
        children: [
          _SummaryRow(
            icon: Icons.handyman_rounded,
            label: 'Servicio',
            value: draft.categoryName,
          ),
          const Divider(color: Color(0xFF383838), height: 28),
          _SummaryRow(
            icon: Icons.person_rounded,
            label: 'Profesional',
            value: draft.professionalName == null
                ? 'Por asignar'
                : '${draft.professionalName} · ${draft.professionalRating ?? '0'}',
          ),
          const Divider(color: Color(0xFF383838), height: 28),
          const _SummaryRow(
            icon: Icons.location_on_rounded,
            label: 'Ubicación',
            value: 'Ubicación actual del cliente',
          ),
          const Divider(color: Color(0xFF383838), height: 28),
          const _SummaryRow(
            icon: Icons.schedule_rounded,
            label: 'Llegada estimada',
            value: 'Según disponibilidad',
          ),
          const Divider(color: Color(0xFF383838), height: 28),
          _SummaryRow(
            icon: Icons.payments_rounded,
            label: 'Valor estimado',
            value: price,
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
  const _NotesBox({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF22221F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalle para el profesional',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
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

class _MissingDraftCard extends StatelessWidget {
  const _MissingDraftCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFF5A52)),
      ),
      child: const Text(
        'Selecciona una categoría y un profesional antes de enviar la solicitud.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
