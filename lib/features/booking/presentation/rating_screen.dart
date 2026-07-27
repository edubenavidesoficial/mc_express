import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';
import 'package:mc_express/features/booking/data/service_requests_api.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _api = ServiceRequestsApi();
  final _commentController = TextEditingController();
  int _rating = 5;
  bool _saving = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft =
        ModalRoute.of(context)?.settings.arguments as ServiceRequestDraft?;
    final professional = draft?.professionalName ?? 'el profesional';
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
          Text(
            'Califica la atención de $professional.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var index = 1; index <= 5; index++)
                IconButton(
                  onPressed: () => setState(() => _rating = index),
                  icon: Icon(
                    index <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: AppTheme.yellow,
                    size: 44,
                  ),
                ),
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
            child: TextField(
              controller: _commentController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Escribe un comentario para ayudar a otros usuarios.',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          const Spacer(),
          AppButton(
            label: _saving ? 'GUARDANDO...' : 'FINALIZAR',
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (draft?.requestId != null && draft?.professionalId != null) {
                setState(() => _saving = true);
                await _api.review(
                  requestId: draft!.requestId!,
                  professionalId: draft.professionalId!,
                  rating: _rating,
                  comment: _commentController.text.trim().isEmpty
                      ? 'Calificación enviada desde la app'
                      : _commentController.text.trim(),
                );
              }
              if (!mounted) return;
              navigator.pushNamedAndRemoveUntil(
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
