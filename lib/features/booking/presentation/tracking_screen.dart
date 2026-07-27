import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

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
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 58,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.servicePayment,
                          arguments: draft,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFCFFF00),
                        foregroundColor: AppTheme.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Ya llegué',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 58,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3B35),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(ServiceRequestDraft? draft) {
    if (draft == null) return 'SOLICITUD';
    return draft.professionalName == null ? 'PENDIENTE' : 'EN PROCESO';
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
      canvas.drawLine(Offset(14, y), Offset(size.width - 14, y + 18), roadPaint);
    }
    for (double x = 22; x < size.width; x += 38) {
      canvas.drawLine(Offset(x, 16), Offset(x - 40, size.height - 20), roadPaint);
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
          _InfoLine(label: 'Servicio:', value: draft?.categoryName ?? 'Servicio'),
          const SizedBox(height: 16),
          _InfoLine(label: 'Profesional:', value: draft?.professionalName ?? 'Por asignar'),
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
