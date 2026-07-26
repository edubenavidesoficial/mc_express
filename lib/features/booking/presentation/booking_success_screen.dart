import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      showBack: false,
      child: Column(
        children: [
          const Spacer(),
          const McWordmark(compact: true),
          const SizedBox(height: 42),
          Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              color: AppTheme.yellow,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.yellow.withValues(alpha: 0.35),
                  blurRadius: 34,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppTheme.black,
              size: 82,
            ),
          ),
          const SizedBox(height: 34),
          const Text(
            'Solicitud enviada',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Carlos aceptó el servicio y va camino a tu ubicación.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.35,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 26),
          const _NotificationCard(),
          const SizedBox(height: 18),
          const _StatusPanel(),
          const Spacer(),
          DemoButton(
            label: 'VER SEGUIMIENTO',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.tracking);
            },
          ),
          const SizedBox(height: 14),
          DemoButton(
            label: 'VOLVER AL INICIO',
            outlined: true,
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.yellow.withValues(alpha: 0.30)),
      ),
      child: const Row(
        children: [
          Icon(Icons.notifications_active_rounded, color: AppTheme.yellow),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Carlos aceptó tu solicitud',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.yellow.withValues(alpha: 0.35)),
      ),
      child: const Column(
        children: [
          _StatusLine(label: 'Llegada estimada', value: '8 min'),
          SizedBox(height: 14),
          _StatusLine(label: 'Distancia', value: '1.2 km'),
          SizedBox(height: 14),
          _StatusLine(label: 'Código de servicio', value: 'MC-2048'),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}
