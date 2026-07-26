import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/search/data/professionals_api.dart';

class ProfessionalsScreen extends StatefulWidget {
  const ProfessionalsScreen({super.key});

  @override
  State<ProfessionalsScreen> createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
  final _professionalsApi = ProfessionalsApi();
  List<ProfessionalDto> _professionals = const [];

  @override
  void initState() {
    super.initState();
    _loadProfessionals();
  }

  Future<void> _loadProfessionals() async {
    try {
      final professionals = await _professionalsApi.list(categoryId: 3);
      if (!mounted) return;
      setState(() {
        _professionals = professionals;
      });
    } catch (_) {
      // Keep demo professionals visible if the API is not available yet.
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = _professionals.isEmpty
        ? const [
            _ProfessionalCard(
              name: 'Carlos M.',
              trade: 'Plomero certificado',
              rating: '4.9',
              distance: '1.2 km',
              eta: '8 min',
              price: r'$28,00',
              selected: true,
            ),
            _ProfessionalCard(
              name: 'Miguel A.',
              trade: 'Instalaciones y fugas',
              rating: '4.8',
              distance: '1.7 km',
              eta: '12 min',
              price: r'$32,00',
            ),
            _ProfessionalCard(
              name: 'José R.',
              trade: 'Emergencias 24/7',
              rating: '4.7',
              distance: '2.4 km',
              eta: '16 min',
              price: r'$35,00',
            ),
          ]
        : [
            for (final professional in _professionals)
              _ProfessionalCard(
                name: professional.fullName,
                trade: professional.category,
                rating: professional.rating,
                distance: 'Cerca',
                eta: 'Disponible',
                price: '\$${professional.basePrice}',
                selected: professional == _professionals.first,
              ),
          ];

    return BrandedScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const McWordmark(compact: true),
          const SizedBox(height: 26),
          const Text(
            'Profesionales cerca de ti',
            style: TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Plomeros disponibles para atender ahora',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 18),
          const _FilterBar(),
          const SizedBox(height: 18),
          Expanded(
            child: ListView(children: cards),
          ),
          const SizedBox(height: 12),
          DemoButton(
            label: 'CONTINUAR CON CARLOS',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.professionalProfile);
            },
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _FilterChip(label: 'Más cerca', active: true),
        SizedBox(width: 10),
        _FilterChip(label: 'Mejor calificado'),
        SizedBox(width: 10),
        _FilterChip(label: 'Precio'),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: active ? AppTheme.yellow : const Color(0xFF181816),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppTheme.yellow : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: active ? AppTheme.black : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  const _ProfessionalCard({
    required this.name,
    required this.trade,
    required this.rating,
    required this.distance,
    required this.eta,
    required this.price,
    this.selected = false,
  });

  final String name;
  final String trade;
  final String rating;
  final String distance;
  final String eta;
  final String price;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selected
          ? () => Navigator.of(context).pushNamed(AppRoutes.professionalProfile)
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF181816),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppTheme.yellow
                : Colors.white.withValues(alpha: 0.10),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppTheme.yellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppTheme.black,
                size: 46,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          color: AppTheme.yellow,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trade,
                    style: const TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MiniStat(icon: Icons.star_rounded, label: rating),
                      _MiniStat(
                        icon: Icons.location_on_rounded,
                        label: distance,
                      ),
                      _MiniStat(icon: Icons.schedule_rounded, label: eta),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.yellow, size: 15),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
