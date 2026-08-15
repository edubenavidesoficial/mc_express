import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';
import 'package:mc_express/features/booking/data/service_requests_api.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _api = ServiceRequestsApi();
  bool _isCancelling = false;

  Future<void> _callProfessional(ServiceRequestDraft? draft) async {
    final phone = draft?.professionalPhone;
    if (phone == null || phone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  }

  Future<void> _cancelWithReason(
    ServiceRequestDraft? draft,
    String reason,
  ) async {
    if (draft?.requestId == null || _isCancelling) return;
    setState(() => _isCancelling = true);
    try {
      await _api.cancelRequest(requestId: draft!.requestId!, reason: reason);
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cancelar la solicitud')),
      );
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
  }

  void _showCancelReasons(ServiceRequestDraft? draft) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final reasons = [
          'El tiempo de espera es muy largo',
          'Ubicación o detalle incorrecto',
          'Quiero cambiar el tipo de servicio',
          'Solicitud accidental',
        ];
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '¿Por qué quieres cancelar?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF4F4F4),
                        foregroundColor: Colors.black,
                      ),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${draft?.professionalName == null ? 'Varios profesionales' : draft!.professionalName} cerca de tu ubicación',
                    style: const TextStyle(
                      color: Color(0xFF6F6F6F),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (final reason in reasons)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.black,
                    ),
                    title: Text(
                      reason,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _cancelWithReason(draft, reason),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft =
        ModalRoute.of(context)?.settings.arguments as ServiceRequestDraft?;
    return BrandedScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 26),
            const Text(
              'MC',
              style: TextStyle(
                color: AppTheme.yellow,
                fontSize: 54,
                fontWeight: FontWeight.w900,
                height: 0.95,
                letterSpacing: 0,
              ),
            ),
            const Text(
              'MC Trabajo Express',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 22),
            const _MapPreview(),
            const SizedBox(height: 18),
            const CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFF111111),
              child: Text(
                'MC',
                style: TextStyle(
                  color: AppTheme.yellow,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _statusLabel(draft),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.yellow,
                fontSize: 48,
                fontWeight: FontWeight.w900,
                height: 1,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 24),
            _TripInfoCard(draft: draft),
            const SizedBox(height: 18),
            _ContactActions(
              enabled: draft?.professionalName != null,
              onCall: () => _callProfessional(draft),
              onMessage: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.serviceChat, arguments: draft),
              onPhoto: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.serviceChat, arguments: draft),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'FINALIZAR SERVICIO',
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.servicePayment, arguments: draft);
              },
              backgroundColor: const Color(0xFFCFFF00),
            ),
            const SizedBox(height: 14),
            AppButton(
              label: _isCancelling ? 'CANCELANDO...' : 'CANCELAR',
              outlined: true,
              onPressed: () => _showCancelReasons(draft),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(ServiceRequestDraft? draft) {
    if (draft == null) return 'SOLICITUD';
    return draft.professionalName == null ? 'BUSCANDO' : 'EN CAMINO';
  }
}

class _ContactActions extends StatelessWidget {
  const _ContactActions({
    required this.enabled,
    required this.onCall,
    required this.onMessage,
    required this.onPhoto,
  });

  final bool enabled;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onPhoto;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppTheme.yellow : const Color(0xFF40403C);
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.call_rounded,
            label: 'Llamar',
            color: color,
            onTap: enabled ? onCall : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.chat_bubble_rounded,
            label: 'Mensaje',
            color: color,
            onTap: enabled ? onMessage : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.photo_camera_rounded,
            label: 'Foto',
            color: color,
            onTap: enabled ? onPhoto : null,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xFF1D1D1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.55)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.35,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF101010),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.yellow, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppTheme.yellow.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _MapPainter(),
          child: const Stack(
            children: [
              Positioned(left: 54, top: 44, child: _MapPin(small: true)),
              Positioned(right: 70, top: 82, child: _MapPin()),
              Positioned(left: 150, bottom: 44, child: _MapPin()),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({this.small = false});

  final bool small;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_on_rounded,
      color: AppTheme.yellow,
      size: small ? 34 : 48,
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final Paint routePaint = Paint()
      ..color = AppTheme.yellow
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (double y = 28; y < size.height; y += 28) {
      canvas.drawLine(
        Offset(14, y),
        Offset(size.width - 14, y + 18),
        roadPaint,
      );
    }
    for (double x = 22; x < size.width; x += 38) {
      canvas.drawLine(
        Offset(x, 16),
        Offset(x - 40, size.height - 20),
        roadPaint,
      );
    }

    final Path route = Path()
      ..moveTo(size.width * 0.22, size.height * 0.32)
      ..quadraticBezierTo(
        size.width * 0.46,
        size.height * 0.18,
        size.width * 0.62,
        size.height * 0.45,
      )
      ..quadraticBezierTo(
        size.width * 0.76,
        size.height * 0.66,
        size.width * 0.48,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.76,
        size.width * 0.60,
        size.height * 0.86,
      );
    canvas.drawPath(route, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TripInfoCard extends StatelessWidget {
  const _TripInfoCard({required this.draft});

  final ServiceRequestDraft? draft;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1D1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _InfoLine(
            label: 'Servicio:',
            value: draft?.categoryName ?? 'Servicio',
          ),
          const SizedBox(height: 16),
          _InfoLine(
            label: 'Profesional:',
            value: draft?.professionalName ?? 'Por asignar',
          ),
          const SizedBox(height: 16),
          _InfoLine(label: 'Código:', value: 'MC-${draft?.requestId ?? '--'}'),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
          children: [
            TextSpan(text: '$label '),
            TextSpan(
              text: "'$value'",
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
