import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mc_express/core/theme/app_theme.dart';

class BrandedScaffold extends StatelessWidget {
  const BrandedScaffold({
    super.key,
    required this.child,
    this.showBack = true,
    this.padding = const EdgeInsets.fromLTRB(24, 14, 24, 24),
  });

  final Widget child;
  final bool showBack;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF050505), Color(0xFF10100E), Color(0xFF000000)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _HoneycombBackground()),
            Positioned(
              top: 116,
              right: -30,
              child: _Bolt(size: 168, opacity: 0.9),
            ),
            Positioned(
              left: -44,
              bottom: 148,
              child: _Bolt(size: 122, opacity: 0.7),
            ),
            SafeArea(
              child: Padding(
                padding: padding,
                child: Column(
                  children: [
                    if (showBack) const BrandedTopBar(),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BrandedTopBar extends StatelessWidget {
  const BrandedTopBar({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: Colors.white,
            iconSize: 34,
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          Expanded(
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class McWordmark extends StatelessWidget {
  const McWordmark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 42 : 56,
          height: compact ? 42 : 56,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.yellow, width: 4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.yellow,
            size: compact ? 28 : 38,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MC',
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 34 : 44,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                height: 0.86,
                letterSpacing: 0,
              ),
            ),
            const Text(
              'TRABAJO EXPRESS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                height: 1,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.bolt_rounded,
          color: AppTheme.yellow,
          size: compact ? 42 : 54,
        ),
      ],
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.outlined = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final bool outlined;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor ?? AppTheme.yellow;
    final Color fg = foregroundColor ?? AppTheme.black;

    return SizedBox(
      width: double.infinity,
      height: 62,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: outlined ? Colors.transparent : bg,
          foregroundColor: outlined ? AppTheme.yellow : fg,
          side: outlined
              ? const BorderSide(color: AppTheme.yellow, width: 2)
              : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: outlined ? AppTheme.yellow : fg,
            fontSize: 19,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF131311),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          _BottomNavItem(
            icon: Icons.home_rounded,
            label: 'Inicio',
            selected: currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/home', (route) => false);
              }
            },
          ),
          _BottomNavItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Billetera',
            selected: currentIndex == 1,
            onTap: () {
              if (currentIndex != 1) {
                Navigator.of(context).pushNamed('/recharge');
              }
            },
          ),
          _BottomNavItem(
            icon: Icons.receipt_long_rounded,
            label: 'Historial',
            selected: currentIndex == 2,
            onTap: () {
              if (currentIndex != 2) {
                Navigator.of(context).pushNamed('/history');
              }
            },
          ),
          _BottomNavItem(
            icon: Icons.person_rounded,
            label: 'Cuenta',
            selected: currentIndex == 3,
            onTap: () {
              if (currentIndex != 3) {
                Navigator.of(context).pushNamed('/account');
              }
            },
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? AppTheme.yellow : AppTheme.mutedText,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? AppTheme.yellow : AppTheme.mutedText,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoneycombBackground extends StatelessWidget {
  const _HoneycombBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _HoneycombPainter());
  }
}

class _HoneycombPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = Colors.white.withValues(alpha: 0.055);
    final Paint yellowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppTheme.yellow.withValues(alpha: 0.16);

    const double radius = 24;
    final double h = math.sqrt(3) * radius;
    for (double y = -h; y < size.height + h; y += h) {
      final int row = (y / h).round();
      for (double x = -radius; x < size.width + radius; x += radius * 3) {
        final double shiftedX = x + (row.isEven ? 0 : radius * 1.5);
        final Path hex = Path();
        for (int i = 0; i < 6; i++) {
          final double angle = math.pi / 6 + i * math.pi / 3;
          final Offset point = Offset(
            shiftedX + radius * math.cos(angle),
            y + radius * math.sin(angle),
          );
          if (i == 0) {
            hex.moveTo(point.dx, point.dy);
          } else {
            hex.lineTo(point.dx, point.dy);
          }
        }
        hex.close();
        final bool highlight = shiftedX > size.width * 0.68 || y < 180;
        canvas.drawPath(hex, highlight ? yellowPaint : paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Bolt extends StatelessWidget {
  const _Bolt({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.1,
      child: Icon(
        Icons.bolt_rounded,
        color: AppTheme.yellow.withValues(alpha: opacity),
        size: size,
      ),
    );
  }
}
