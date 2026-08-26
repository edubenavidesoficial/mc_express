import 'package:flutter/material.dart';
import 'package:mc_express/core/constants/app_assets.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/security/session_lock_service.dart';
import 'package:mc_express/core/storage/session_store.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/primary_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectIfLoggedIn());
  }

  Future<void> _redirectIfLoggedIn() async {
    final isLoggedIn = await SessionStore.instance.isLoggedIn;
    if (!mounted) return;
    if (!isLoggedIn) {
      setState(() => _isCheckingSession = false);
      return;
    }
    final unlocked = await SessionLockService.instance.authenticate();
    if (!mounted) return;
    if (unlocked) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } else {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.auth, (route) => false);
    }
  }

  Future<void> _continue(BuildContext context) async {
    final isLoggedIn = await SessionStore.instance.isLoggedIn;
    if (!context.mounted) return;
    if (!isLoggedIn) {
      Navigator.of(context).pushNamed(AppRoutes.accountType);
      return;
    }
    final unlocked = await SessionLockService.instance.authenticate();
    if (!context.mounted) return;
    if (unlocked) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } else {
      Navigator.of(context).pushNamed(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSession) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.yellow)),
      );
    }

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
                      onPressed: () => _continue(context),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.professionals);
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

class _SearchPreview extends StatefulWidget {
  const _SearchPreview();

  @override
  State<_SearchPreview> createState() => _SearchPreviewState();
}

class _SearchPreviewState extends State<_SearchPreview> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final query = _controller.text.trim();
    Navigator.of(context).pushNamed(
      AppRoutes.professionals,
      arguments: query.isEmpty ? null : query,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.only(left: 16, right: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppTheme.black),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _search(),
              style: const TextStyle(
                color: AppTheme.black,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Plomero, electricista, pintor...',
                hintStyle: TextStyle(
                  color: Color(0xFF5C5C5C),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _search,
            icon: const Icon(Icons.tune_rounded, color: AppTheme.black),
          ),
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
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.professionals, arguments: label);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
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
      ),
    );
  }
}
