import 'package:flutter/material.dart';
import 'package:mc_express/core/constants/app_assets.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/primary_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool compact = constraints.maxHeight < 720;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 42,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LocationPill(compact: compact),
                    SizedBox(height: compact ? 22 : 34),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          AppAssets.logo,
                          width: compact ? 190 : 240,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 26 : 38),
                    Text(
                      'Encuentra profesionales cerca de ti',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Servicios rápidos para el hogar, emergencias y trabajos puntuales desde tu ubicación.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    const _SearchPreview(),
                    const SizedBox(height: 18),
                    const _CategoryRow(),
                    SizedBox(height: compact ? 30 : 46),
                    PrimaryButton(
                      label: 'Ingresar a MC Express',
                      icon: Icons.login_rounded,
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.auth);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.home);
                      },
                      child: const Text(
                        'Explorar servicios',
                        style: TextStyle(
                          color: AppTheme.yellow,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        'Conectado a MC Express',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LocationPill extends StatelessWidget {
  const _LocationPill({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.charcoal,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.near_me_rounded, color: AppTheme.yellow, size: 18),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Profesionales cerca de tu ubicación',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppTheme.softWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPreview extends StatelessWidget {
  const _SearchPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: AppTheme.black),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Plomero, electricista, pintor...',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF5C5C5C),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(Icons.tune_rounded, color: AppTheme.black),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    const categories = ['Hogar', 'Emergencia', 'Mantenimiento'];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final category in categories) _CategoryChip(label: category),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.charcoal,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.amber.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.softWhite,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
