import 'package:flutter/material.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 10),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const McWordmark(compact: true),
          const SizedBox(height: 24),
          const Text(
            'Historial',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: ListView(
              children: const [
                Text(
                  'Historial de Recargas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 18),
                _HistoryCard(
                  amount: r'$20.00',
                  method: 'Tarjeta de Crédito',
                  status: 'Verificado',
                  statusColor: AppTheme.yellow,
                  icon: Icons.verified_rounded,
                ),
                _HistoryCard(
                  amount: r'$20.00',
                  method: 'Tarjeta de Crédito',
                  status: 'Completado',
                  statusColor: Color(0xFF42D268),
                ),
                _HistoryCard(
                  amount: r'$20.00',
                  method: 'Tarjeta de Crédito',
                  status: 'Pendiente',
                  statusColor: Color(0xFFFF4545),
                ),
                _HistoryCard(
                  amount: r'$20.00',
                  method: 'Tarjeta de Crédito',
                  status: 'Pendiente',
                  statusColor: Color(0xFFFF4545),
                ),
                _HistoryCard(
                  amount: r'$20.00',
                  method: 'Tarjeta de Crédito',
                  status: '',
                  statusColor: AppTheme.yellow,
                  icon: Icons.keyboard_arrow_down_rounded,
                ),
              ],
            ),
          ),
          const DemoBottomNav(currentIndex: 2),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.amount,
    required this.method,
    required this.status,
    required this.statusColor,
    this.icon,
  });

  final String amount;
  final String method;
  final String status;
  final Color statusColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hoy, 15:30',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  method,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.25),
                  blurRadius: 18,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: icon == null
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    color: statusColor == AppTheme.yellow
                        ? AppTheme.black
                        : Colors.white,
                    size: 42,
                  ),
          ),
        ],
      ),
    );
  }
}
