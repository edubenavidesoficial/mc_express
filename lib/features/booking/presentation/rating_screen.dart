import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      showBack: false,
      child: Column(
        children: [
          const Spacer(),
          const McWordmark(compact: true),
          const SizedBox(height: 34),
          const CircleAvatar(
            radius: 46,
            backgroundColor: AppTheme.yellow,
            child: Icon(Icons.person_rounded, color: AppTheme.black, size: 64),
          ),
          const SizedBox(height: 22),
          const Text(
            'Servicio completado',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Califica la atención de Carlos M.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 28),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_rounded, color: AppTheme.yellow, size: 44),
              Icon(Icons.star_rounded, color: AppTheme.yellow, size: 44),
              Icon(Icons.star_rounded, color: AppTheme.yellow, size: 44),
              Icon(Icons.star_rounded, color: AppTheme.yellow, size: 44),
              Icon(Icons.star_rounded, color: AppTheme.yellow, size: 44),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            height: 118,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF20201D),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.topLeft,
            child: Text(
              'Excelente servicio, llegó rápido y resolvió el problema.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.3,
                letterSpacing: 0,
              ),
            ),
          ),
          const Spacer(),
          DemoButton(
            label: 'FINALIZAR DEMO',
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
