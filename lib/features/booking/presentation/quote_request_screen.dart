import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';

class QuoteRequestScreen extends StatelessWidget {
  const QuoteRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Center(child: McWordmark(compact: true)),
            const SizedBox(height: 36),
            const Text(
              'Solicitar cotización',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                height: 1,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Describe el trabajo y recibe una propuesta del profesional.',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.35,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 24),
            const _QuoteField(
              icon: Icons.build_rounded,
              label: 'Tipo de servicio',
              value: 'Reparación de fuga / plomería',
            ),
            const SizedBox(height: 14),
            const _LargeQuoteField(),
            const SizedBox(height: 14),
            const _PhotoBox(),
            const SizedBox(height: 22),
            DemoButton(
              label: 'ENVIAR COTIZACIÓN',
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.professionals);
              },
            ),
            const SizedBox(height: 14),
            DemoButton(
              label: 'USAR SERVICIO RÁPIDO',
              outlined: true,
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.professionals);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteField extends StatelessWidget {
  const _QuoteField({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
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
                const SizedBox(height: 4),
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
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeQuoteField extends StatelessWidget {
  const _LargeQuoteField();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 154,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF20201D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: const Text(
        'El lavamanos pierde agua desde la base. Necesito revisión y reparación hoy.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.35,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _PhotoBox extends StatelessWidget {
  const _PhotoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.yellow.withValues(alpha: 0.35)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_rounded, color: AppTheme.yellow, size: 30),
          SizedBox(width: 12),
          Text(
            'Foto adjunta del problema',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
