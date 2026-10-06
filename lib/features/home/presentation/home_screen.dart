import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/features/booking/data/service_request_draft.dart';
import 'package:mc_express/features/search/data/professionals_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _ambato = gmaps.LatLng(-1.2491, -78.6168);
  final _searchController = TextEditingController();
  final _professionalsApi = ProfessionalsApi();
  gmaps.GoogleMapController? _mapController;
  late Future<List<CategoryDto>> _categories;
  gmaps.LatLng _clientLocation = _ambato;
  String _serviceLocation = 'Detectando ubicación…';
  bool _isLocating = true;

  @override
  void initState() {
    super.initState();
    _categories = _professionalsApi.categories();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrentLocation());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search([String? value]) {
    final query = (value ?? _searchController.text).trim();
    Navigator.of(context).pushNamed(
      AppRoutes.professionals,
      arguments: query.isEmpty ? null : query,
    );
  }

  void _selectCategory(CategoryDto category) {
    if (category.id == 0) {
      _search(category.name);
      return;
    }
    Navigator.of(context).pushNamed(
      AppRoutes.professionals,
      arguments: ServiceRequestDraft(
        categoryId: category.id,
        categoryName: category.name,
      ),
    );
  }

  Future<void> _loadCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw StateError('El servicio de ubicación está desactivado.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw StateError('No autorizaste el acceso a la ubicación.');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      final location = gmaps.LatLng(position.latitude, position.longitude);
      var label = 'Tu ubicación actual';
      try {
        final placemarks = await geocoding.Geocoding(
          locale: const Locale('es', 'EC'),
        ).placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          label =
              _firstNonEmpty([
                place.locality,
                place.subAdministrativeArea,
                place.administrativeArea,
              ]) ??
              label;
        }
      } catch (_) {
        // GPS data remains useful even if the device cannot resolve the city.
      }

      if (!mounted) return;
      setState(() {
        _clientLocation = location;
        _serviceLocation = label;
        _isLocating = false;
      });
      _mapController?.animateCamera(
        gmaps.CameraUpdate.newLatLngZoom(location, 14.8),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _serviceLocation = 'Ubicación no disponible';
        _isLocating = false;
      });
    }
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _DarkCityMap(
              center: _ambato,
              clientLocation: _clientLocation,
              onMapCreated: (controller) {
                _mapController = controller;
                if (!_isLocating) {
                  controller.animateCamera(
                    gmaps.CameraUpdate.newLatLngZoom(_clientLocation, 14.8),
                  );
                }
              },
            ),
          ),
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Positioned(
                  top: 18,
                  left: 18,
                  child: _RoundMapButton(
                    icon: Icons.menu_rounded,
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.account),
                  ),
                ),
                Positioned(
                  top: 115,
                  left: 0,
                  right: 0,
                  child: _ServiceLocation(
                    locationName: _serviceLocation,
                    isLocating: _isLocating,
                  ),
                ),
                Positioned(
                  right: 18,
                  bottom: 390 + bottomInset,
                  child: _RoundMapButton(
                    icon: Icons.navigation_rounded,
                    onTap: _loadCurrentLocation,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _DiscoverSheet(
              controller: _searchController,
              categories: _categories,
              onSearch: _search,
              onSelectCategory: _selectCategory,
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkCityMap extends StatelessWidget {
  const _DarkCityMap({
    required this.center,
    required this.clientLocation,
    required this.onMapCreated,
  });
  final gmaps.LatLng center;
  final gmaps.LatLng clientLocation;
  final ValueChanged<gmaps.GoogleMapController> onMapCreated;

  @override
  Widget build(BuildContext context) {
    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(target: center, zoom: 14.3),
      onMapCreated: onMapCreated,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      zoomControlsEnabled: false,
      style: _darkMapStyle,
      markers: {
        gmaps.Marker(
          markerId: const gmaps.MarkerId('client'),
          position: clientLocation,
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            gmaps.BitmapDescriptor.hueAzure,
          ),
        ),
        ..._MapPoints.trades.map(
          (point) => gmaps.Marker(
            markerId: gmaps.MarkerId(point.$1),
            position: point.$2,
            infoWindow: gmaps.InfoWindow(title: point.$1),
          ),
        ),
      },
    );
  }
}

const _darkMapStyle = '''[
  {"elementType":"geometry","stylers":[{"color":"#161616"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#161616"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#303030"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#050505"}]},
  {"featureType":"poi","stylers":[{"visibility":"off"}]}
]''';

class _MapPoints {
  static const trades = [
    ('Albañil', gmaps.LatLng(-1.2457, -78.6219)),
    ('Electricista', gmaps.LatLng(-1.2437, -78.6117)),
    ('Plomero', gmaps.LatLng(-1.2527, -78.6096)),
    ('Pintor', gmaps.LatLng(-1.2541, -78.6223)),
  ];
}

class _RoundMapButton extends StatelessWidget {
  const _RoundMapButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFF202020),
    shape: const CircleBorder(),
    elevation: 10,
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 58,
        height: 58,
        child: Icon(icon, color: Colors.white, size: 31),
      ),
    ),
  );
}

class _ServiceLocation extends StatelessWidget {
  const _ServiceLocation({
    required this.locationName,
    required this.isLocating,
  });

  final String locationName;
  final bool isLocating;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      padding: const EdgeInsets.fromLTRB(15, 11, 10, 11),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1D1D),
        borderRadius: BorderRadius.circular(17),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 16)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Punto de servicio',
                style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
              ),
              Text(
                locationName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(width: 22),
          isLocating
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppTheme.yellow,
                    strokeWidth: 2.5,
                  ),
                )
              : const Icon(
                  Icons.my_location_rounded,
                  color: Colors.white,
                  size: 24,
                ),
        ],
      ),
    ),
  );
}

class _DiscoverSheet extends StatelessWidget {
  const _DiscoverSheet({
    required this.controller,
    required this.categories,
    required this.onSearch,
    required this.onSelectCategory,
  });
  final TextEditingController controller;
  final Future<List<CategoryDto>> categories;
  final ValueChanged<String> onSearch;
  final ValueChanged<CategoryDto> onSelectCategory;
  @override
  Widget build(BuildContext context) => Container(
    height: 365 + MediaQuery.paddingOf(context).bottom,
    padding: EdgeInsets.fromLTRB(
      18,
      9,
      18,
      14 + MediaQuery.paddingOf(context).bottom,
    ),
    decoration: const BoxDecoration(
      color: Color(0xFF111111),
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    child: Column(
      children: [
        Container(
          width: 42,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF858585),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 104,
          child: _CategoryCarousel(
            categories: categories,
            onSelect: onSelectCategory,
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: controller,
          onSubmitted: onSearch,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF242424),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Colors.white,
              size: 32,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.arrow_forward_rounded,
                color: AppTheme.yellow,
              ),
              onPressed: () => onSearch(controller.text),
            ),
            hintText: '¿Qué servicio necesitas?',
            hintStyle: const TextStyle(
              color: Color(0xFFD6D6D6),
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _RecentSearches(),
      ],
    ),
  );
}

class _CategoryCarousel extends StatelessWidget {
  const _CategoryCarousel({required this.categories, required this.onSelect});
  final Future<List<CategoryDto>> categories;
  final ValueChanged<CategoryDto> onSelect;
  static const _fallback = [
    CategoryDto(id: 0, name: 'Albañil'),
    CategoryDto(id: 0, name: 'Electricista'),
    CategoryDto(id: 0, name: 'Plomero'),
    CategoryDto(id: 0, name: 'Pintor'),
  ];
  @override
  Widget build(BuildContext context) => FutureBuilder<List<CategoryDto>>(
    future: categories,
    builder: (context, snapshot) {
      final items = snapshot.data?.isNotEmpty == true
          ? snapshot.data!
          : _fallback;
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _CategoryTile(
          category: items[index],
          onTap: () => onSelect(items[index]),
        ),
      );
    },
  );
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});
  final CategoryDto category;
  final VoidCallback onTap;
  IconData get _icon {
    final name = category.name.toLowerCase();
    if (name.contains('elect')) return Icons.electric_bolt_rounded;
    if (name.contains('plom')) return Icons.plumbing_rounded;
    if (name.contains('pint')) return Icons.format_paint_rounded;
    return Icons.engineering_rounded;
  }

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      width: 106,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(child: Icon(_icon, size: 49, color: AppTheme.yellow)),
          ),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const Text(
            '●  Cerca',
            style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches();
  @override
  Widget build(BuildContext context) => const Column(
    children: [
      _RecentRow(title: 'Servicio cerca de tu ubicación', subtitle: 'Ambato'),
      SizedBox(height: 15),
      _RecentRow(
        title: 'Cotiza un servicio personalizado',
        subtitle: 'Describe lo que necesitas',
      ),
    ],
  );
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.history_rounded, color: Color(0xFFBDBDBD), size: 30),
      const SizedBox(width: 17),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 15),
            ),
          ],
        ),
      ),
    ],
  );
}
