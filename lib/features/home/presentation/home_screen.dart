import 'package:flutter/material.dart';
import 'package:mc_express/core/constants/app_assets.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';
import 'package:mc_express/features/search/data/professionals_api.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF050505), Color(0xFF0A0A0A), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool compact = constraints.maxHeight < 730;
              final double horizontalPadding = constraints.maxWidth > 430
                  ? 34
                  : 22;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  compact ? 10 : 18,
                  horizontalPadding,
                  24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 34,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TopBar(),
                      SizedBox(height: compact ? 18 : 28),
                      Center(
                        child: Image.asset(
                          AppAssets.logo,
                          width: compact ? 210 : 248,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: compact ? 26 : 36),
                      const _HeroTitle(),
                      SizedBox(height: compact ? 18 : 24),
                      const _ServiceSearchField(),
                      SizedBox(height: compact ? 24 : 32),
                      const Text(
                        'CATEGORÍAS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _CategoryGrid(),
                      SizedBox(height: compact ? 24 : 32),
                      const _RequestServiceButton(),
                      const AppBottomNav(currentIndex: 0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.yellow,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppTheme.yellow.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.handshake_rounded,
            color: AppTheme.black,
            size: 24,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.quoteRequest);
          },
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.yellow,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          ),
          child: const Text(
            'COTIZACION',
            style: TextStyle(
              color: AppTheme.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿QUÉ SERVICIO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            height: 1.04,
            letterSpacing: 0,
          ),
        ),
        Text(
          'NECESITAS?',
          style: TextStyle(
            color: AppTheme.yellow,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            height: 1.04,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _ServiceSearchField extends StatefulWidget {
  const _ServiceSearchField();

  @override
  State<_ServiceSearchField> createState() => _ServiceSearchFieldState();
}

class _ServiceSearchFieldState extends State<_ServiceSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.42),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _search,
              style: const TextStyle(
                color: AppTheme.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Buscar servicio...',
                hintStyle: TextStyle(
                  color: Color(0xFF777777),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _search(_controller.text),
            icon: const Icon(
              Icons.search_rounded,
              color: AppTheme.black,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  void _search(String value) {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.professionals, arguments: value.trim());
  }
}

class _CategoryGrid extends StatefulWidget {
  const _CategoryGrid();

  @override
  State<_CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<_CategoryGrid> {
  final _professionalsApi = ProfessionalsApi();
  late Future<List<CategoryDto>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _professionalsApi.categories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryDto>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 170,
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.yellow),
            ),
          );
        }
        if (snapshot.hasError) {
          return _ApiMessage(
            message: 'No se pudieron cargar las categorías.',
            onRetry: () {
              setState(() {
                _categoriesFuture = _professionalsApi.categories();
              });
            },
          );
        }

        final categories = snapshot.data ?? const [];
        if (categories.isEmpty) {
          return const _ApiMessage(message: 'Aún no hay categorías activas.');
        }

        return GridView.builder(
          itemCount: categories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(
              category: _ServiceCategory(
                id: category.id,
                label: category.name,
                icon: _iconForCategory(category.name),
              ),
            );
          },
        );
      },
    );
  }

  IconData _iconForCategory(String name) {
    final value = name.toLowerCase();
    if (value.contains('alba')) return Icons.engineering_rounded;
    if (value.contains('jardin')) return Icons.energy_savings_leaf_rounded;
    if (value.contains('plom')) return Icons.plumbing_rounded;
    if (value.contains('elect')) return Icons.bolt_rounded;
    if (value.contains('pint')) return Icons.format_paint_rounded;
    return Icons.handyman_rounded;
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final _ServiceCategory category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.professionals,
          arguments: ServiceRequestDraft(
            categoryId: category.id,
            categoryName: category.label,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0C0C0C),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF3E3E3E), width: 1.8),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.50),
              blurRadius: 12,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 12, 6, 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, color: AppTheme.yellow, size: 42),
              const SizedBox(height: 11),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  category.label,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestServiceButton extends StatelessWidget {
  const _RequestServiceButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: FilledButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.quoteRequest);
        },
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.yellow,
          foregroundColor: AppTheme.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'NECESITO OTRO SERVICIO',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
            SizedBox(width: 22),
            Icon(Icons.chevron_right_rounded, color: AppTheme.black, size: 42),
          ],
        ),
      ),
    );
  }
}

class _ServiceCategory {
  const _ServiceCategory({
    required this.id,
    required this.label,
    required this.icon,
  });

  final int id;
  final String label;
  final IconData icon;
}

class _ApiMessage extends StatelessWidget {
  const _ApiMessage({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            TextButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ],
      ),
    );
  }
}
