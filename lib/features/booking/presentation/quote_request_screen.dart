import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';

class QuoteRequestScreen extends StatefulWidget {
  const QuoteRequestScreen({super.key});

  @override
  State<QuoteRequestScreen> createState() => _QuoteRequestScreenState();
}

class _QuoteRequestScreenState extends State<QuoteRequestScreen> {
  final _serviceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _serviceController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            _QuoteField(
              icon: Icons.build_rounded,
              label: 'Tipo de servicio',
              controller: _serviceController,
            ),
            const SizedBox(height: 14),
            _LargeQuoteField(controller: _descriptionController),
            const SizedBox(height: 14),
            AppButton(
              label: 'BUSCAR PROFESIONAL',
              onPressed: () {
                final query = [
                  _serviceController.text.trim(),
                  _descriptionController.text.trim(),
                ].where((value) => value.isNotEmpty).join(' - ');
                Navigator.of(context).pushNamed(
                  AppRoutes.professionals,
                  arguments: query,
                );
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
    required this.controller,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;

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
                TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ej. Reparación, instalación, mantenimiento',
                    hintStyle: TextStyle(color: AppTheme.mutedText),
                    isDense: true,
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
  const _LargeQuoteField({required this.controller});

  final TextEditingController controller;

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
      child: TextField(
        controller: controller,
        maxLines: 5,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.35,
          letterSpacing: 0,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Describe el trabajo que necesitas',
          hintStyle: TextStyle(color: AppTheme.mutedText),
        ),
      ),
    );
  }
}
