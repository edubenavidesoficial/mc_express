import 'package:flutter/material.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';
import 'package:mc_express/features/search/data/professionals_api.dart';

class ProfessionalsScreen extends StatefulWidget {
  const ProfessionalsScreen({super.key});

  @override
  State<ProfessionalsScreen> createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
  final _professionalsApi = ProfessionalsApi();
  List<ProfessionalDto> _professionals = const [];
  ProfessionalDto? _selectedProfessional;
  ServiceRequestDraft? _draft;
  String _query = '';
  bool _isLoading = true;
  String? _error;

  List<ProfessionalDto> get _filteredProfessionals {
    final cleanQuery = _query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return _professionals;
    return _professionals.where((professional) {
      return professional.fullName.toLowerCase().contains(cleanQuery) ||
          professional.category.toLowerCase().contains(cleanQuery);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is ServiceRequestDraft) {
        _draft = arguments;
        _query = arguments.description ?? '';
      }
      if (arguments is String) {
        _query = arguments;
      }
      _loadProfessionals();
    });
  }

  Future<void> _loadProfessionals() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final professionals = await _professionalsApi.list(
        categoryId: _draft?.categoryId,
      );
      if (!mounted) return;
      setState(() {
        _professionals = professionals;
        _selectedProfessional = professionals.isEmpty
            ? null
            : professionals.first;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = 'No se pudieron cargar profesionales.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openSelectedProfessional() {
    final professional = _selectedProfessional;
    if (professional == null) return;
    final draft =
        (_draft ??
                ServiceRequestDraft(
                  categoryId: professional.categoryId,
                  categoryName: professional.category,
                ))
            .copyWith(
              professionalId: professional.id,
              professionalName: professional.fullName,
              professionalRating: professional.rating,
              description: _query.trim().isEmpty
                  ? 'Solicitud de ${professional.category} creada desde la app.'
                  : _query.trim(),
              estimatedPrice: double.tryParse(professional.basePrice),
            );
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.professionalProfile, arguments: draft);
  }

  void _requestToAllProfessionals() {
    final matches = _filteredProfessionals;
    if (matches.isEmpty) return;
    final professional = matches.first;
    final draft =
        (_draft ??
                ServiceRequestDraft(
                  categoryId: professional.categoryId,
                  categoryName: professional.category,
                ))
            .copyWith(
              professionalId: null,
              professionalName: null,
              professionalRating: null,
              description: _query.trim().isEmpty
                  ? 'Solicitud de ${professional.category} creada desde la app.'
                  : _query.trim(),
              estimatedPrice: double.tryParse(professional.basePrice),
            );
    Navigator.of(context).pushNamed(AppRoutes.bookingSummary, arguments: draft);
  }

  @override
  Widget build(BuildContext context) {
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
          Text(
            _draft == null
                ? 'Profesionales disponibles para atender ahora'
                : '${_draft!.categoryName} disponibles para atender ahora',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 18),
          _SearchBox(
            initialValue: _query,
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 12),
          const _FilterBar(),
          const SizedBox(height: 18),
          Expanded(
            child: _ProfessionalsBody(
              isLoading: _isLoading,
              error: _error,
              professionals: _filteredProfessionals,
              selectedProfessional: _selectedProfessional,
              onRetry: _loadProfessionals,
              onSelect: (professional) {
                setState(() => _selectedProfessional = professional);
              },
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: _filteredProfessionals.isEmpty
                ? 'BUSCA UN SERVICIO DISPONIBLE'
                : 'SOLICITAR AHORA A PROFESIONALES',
            onPressed: _requestToAllProfessionals,
          ),
          const SizedBox(height: 10),
          AppButton(
            label: _selectedProfessional == null
                ? 'SELECCIONA UN PROFESIONAL'
                : 'CONTINUAR CON ${_selectedProfessional!.fullName.toUpperCase()}',
            onPressed: _openSelectedProfessional,
            outlined: true,
          ),
        ],
      ),
    );
  }
}

class _ProfessionalsBody extends StatelessWidget {
  const _ProfessionalsBody({
    required this.isLoading,
    required this.error,
    required this.professionals,
    required this.selectedProfessional,
    required this.onRetry,
    required this.onSelect,
  });

  final bool isLoading;
  final String? error;
  final List<ProfessionalDto> professionals;
  final ProfessionalDto? selectedProfessional;
  final VoidCallback onRetry;
  final ValueChanged<ProfessionalDto> onSelect;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.yellow),
      );
    }
    if (error != null) {
      return _StateMessage(
        message: error!,
        actionLabel: 'Reintentar',
        onTap: onRetry,
      );
    }
    if (professionals.isEmpty) {
      return const _StateMessage(
        message: 'No hay profesionales disponibles para esta búsqueda.',
      );
    }

    return ListView(
      children: [
        const _BroadcastInfoCard(),
        const SizedBox(height: 12),
        for (final professional in professionals)
          _ProfessionalCard(
            name: professional.fullName,
            trade: professional.category,
            rating: professional.rating,
            distance: 'Cerca',
            eta: 'Disponible',
            price: '\$${professional.basePrice}',
            selected: professional.id == selectedProfessional?.id,
            onTap: () => onSelect(professional),
          ),
      ],
    );
  }
}

class _BroadcastInfoCard extends StatelessWidget {
  const _BroadcastInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.yellow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.notifications_active_rounded,
            color: Colors.black,
            size: 30,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Toca “Solicitar ahora” para enviar tu solicitud a todos los profesionales disponibles de este servicio.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.initialValue, required this.onChanged});

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        hintText: 'Buscar por servicio o profesional',
        hintStyle: const TextStyle(color: AppTheme.mutedText),
        prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.yellow),
        filled: true,
        fillColor: const Color(0xFF181816),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.yellow, width: 2),
        ),
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
            color: active
                ? AppTheme.yellow
                : Colors.white.withValues(alpha: 0.12),
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
    required this.onTap,
  });

  final String name;
  final String trade;
  final String rating;
  final String distance;
  final String eta;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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

class _StateMessage extends StatelessWidget {
  const _StateMessage({required this.message, this.actionLabel, this.onTap});

  final String message;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF181816),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              if (actionLabel != null && onTap != null) ...[
                const SizedBox(height: 10),
                TextButton(onPressed: onTap, child: Text(actionLabel!)),
              ],
            ],
          ),
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
