import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';

class ProfessionalProfileScreen extends StatelessWidget {
  const ProfessionalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const _Header(),
            const SizedBox(height: 20),
            const _StatsRow(),
            const SizedBox(height: 18),
            const _Specialties(),
            const SizedBox(height: 18),
            const _ReviewCard(),
            const SizedBox(height: 22),
            DemoButton(
              label: 'SOLICITAR A CARLOS',
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.bookingSummary);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.yellow.withValues(alpha: 0.5)),
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppTheme.yellow,
            child: Icon(Icons.person_rounded, color: AppTheme.black, size: 66),
          ),
          SizedBox(height: 14),
          Text(
            'Carlos M.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Plomero certificado · Disponible ahora',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatBox(label: 'Rating', value: '4.9')),
        SizedBox(width: 10),
        Expanded(child: _StatBox(label: 'Servicios', value: '312')),
        SizedBox(width: 10),
        Expanded(child: _StatBox(label: 'Llegada', value: '8 min')),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: const Color(0xFF20201D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.yellow,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _Specialties extends StatelessWidget {
  const _Specialties();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Especialidades',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SkillChip(label: 'Fugas'),
              _SkillChip(label: 'Lavamanos'),
              _SkillChip(label: 'Tuberías'),
              _SkillChip(label: 'Emergencias'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.yellow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.black,
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF20201D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_rounded, color: AppTheme.yellow, size: 24),
              Icon(Icons.star_rounded, color: AppTheme.yellow, size: 24),
              Icon(Icons.star_rounded, color: AppTheme.yellow, size: 24),
              Icon(Icons.star_rounded, color: AppTheme.yellow, size: 24),
              Icon(Icons.star_half_rounded, color: AppTheme.yellow, size: 24),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '“Llegó rápido y solucionó la fuga sin ensuciar. Muy recomendado.”',
            style: TextStyle(
              color: Colors.white,
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
