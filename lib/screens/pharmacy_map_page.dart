import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';

// ---------------------------------------------------------------------------
// Sabit baslangic konumu: Umraniye - Istiklal Mahallesi, Aleyna Sokak
// ---------------------------------------------------------------------------
const LatLng _kUserLocation = LatLng(41.02560, 29.09630);
const String _kUserAddress =
    "Istiklal Mahallesi, Aleyna Sokak, Umraniye / Istanbul";

// ---------------------------------------------------------------------------
// Gerçek Ümraniye eczane verileri
// ---------------------------------------------------------------------------
const List<_PharmacyData> _kPharmacies = [
  _PharmacyData(
    name: "Kazım Karabekir Eczanesi",
    address: "Kazım Karabekir Mah. Adem Yavuz Cad. No:32, Ümraniye",
    phone: "0216 632 44 00",
    lat: 41.0168,
    lng: 29.1142,
    isOnDuty: false,
  ),
  _PharmacyData(
    name: "İnkılap Eczanesi",
    address: "Namık Kemal Mah. Sütçü İmam Cad. No:100/A, Ümraniye",
    phone: "0216 461 39 19",
    lat: 41.0228,
    lng: 29.0882,
    isOnDuty: false,
  ),
  _PharmacyData(
    name: "Armağanevler Eczanesi",
    address: "Armağanevler Mah. Mithat Paşa Cad. No:144/B, Ümraniye",
    phone: "0216 335 43 86",
    lat: 41.0195,
    lng: 29.0821,
    isOnDuty: false,
  ),
  _PharmacyData(
    name: "Madenler Eczanesi",
    address:
        "Madenler Mah. İdealist Kent Cad. No:5/4, İdealist Park AVM, Ümraniye",
    phone: "0216 590 03 53",
    lat: 41.0381,
    lng: 29.1205,
    isOnDuty: true,
  ),
  _PharmacyData(
    name: "Elmalıkent Eczanesi",
    address: "Elmalıkent Mah. Adem Yavuz Cad. No:79/A, Ümraniye",
    phone: "0216 631 27 17",
    lat: 41.0142,
    lng: 29.1088,
    isOnDuty: false,
  ),
  _PharmacyData(
    name: "Atatürk Eczanesi",
    address: "Atatürk Mah. Çavuşbaşı Cad. No:80/A, Ümraniye",
    phone: "0554 405 80 90",
    lat: 41.0075,
    lng: 29.0965,
    isOnDuty: false,
  ),
  _PharmacyData(
    name: "Canpark Eczanesi",
    address: "Yamanevler Mah. Alemdağ Cad. No:169, Canpark AVM Z08, Ümraniye",
    phone: "0216 510 42 48",
    lat: 41.0312,
    lng: 29.1045,
    isOnDuty: true,
  ),
  _PharmacyData(
    name: "Ihlamurkuyu Eczanesi",
    address: "Ihlamurkuyu Mah. Alemdağ Cad. No:1/B, Ümraniye",
    phone: "0216 540 25 60",
    lat: 41.0358,
    lng: 29.0998,
    isOnDuty: false,
  ),
  _PharmacyData(
    name: "Şerifali Eczanesi",
    address: "Şerifali Mah. İbrahim Hakkı Sok. No:13A, Ümraniye",
    phone: "0216 508 10 70",
    lat: 41.0052,
    lng: 29.1178,
    isOnDuty: false,
  ),
  _PharmacyData(
    name: "İstiklal Eczanesi",
    address: "İstiklal Mah. Anafartalar Cad. No:3/B, Ümraniye",
    phone: "0216 461 39 19",
    lat: 41.0263,
    lng: 29.0945,
    isOnDuty: true,
  ),
  _PharmacyData(
    name: "Çakmak Eczanesi",
    address: "Çakmak Mah. Tavukçu Yolu Üzeri, Ümraniye",
    phone: "0216 332 15 00",
    lat: 41.0118,
    lng: 29.0788,
    isOnDuty: false,
  ),
  _PharmacyData(
    name: "Son Durak Eczanesi",
    address: "Yamanevler Mah. Küçüksu Cad. No:19B, Canpark AVM Yolu, Ümraniye",
    phone: "0216 461 82 30",
    lat: 41.0285,
    lng: 29.1015,
    isOnDuty: true,
  ),
];

// ---------------------------------------------------------------------------
// Veri modeli
// ---------------------------------------------------------------------------
class _PharmacyData {
  final String name;
  final String address;
  final String phone;
  final double lat;
  final double lng;
  final bool isOnDuty;

  const _PharmacyData({
    required this.name,
    required this.address,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.isOnDuty,
  });

  LatLng get latLng => LatLng(lat, lng);

  int distanceMetersFrom(LatLng origin) {
    const d = Distance();
    return d.as(LengthUnit.Meter, origin, latLng).round();
  }

  String distanceTextFrom(LatLng origin) {
    final m = distanceMetersFrom(origin);
    return m >= 1000 ? "${(m / 1000).toStringAsFixed(1)} km" : "$m m";
  }
}

// ---------------------------------------------------------------------------
// Navigasyon yardımcısı
// ---------------------------------------------------------------------------
Future<void> _openGoogleMapsNavigation(
  BuildContext context,
  _PharmacyData pharmacy,
) async {
  final encodedOrigin = Uri.encodeComponent(_kUserAddress);
  final encodedDestination = Uri.encodeComponent(
    "${pharmacy.name}, ${pharmacy.address}",
  );
  final webDirectionsUrl = Uri.parse(
    "https://www.google.com/maps/dir/?api=1&origin=$encodedOrigin&destination=$encodedDestination&travelmode=driving",
  );
  final classicDirectionsUrl = Uri.parse(
    "https://maps.google.com/maps?saddr=$encodedOrigin&daddr=$encodedDestination&dirflg=d",
  );
  final webSearchUrl = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=$encodedDestination",
  );

  final urls = [
    classicDirectionsUrl,
    webDirectionsUrl,
    webSearchUrl,
    Uri.parse("google.navigation:q=$encodedDestination&mode=d"),
    Uri.parse("geo:0,0?q=$encodedDestination"),
  ];

  for (final url in urls) {
    try {
      final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (opened) return;
    } catch (_) {
      // Siradaki Google Maps acma yontemini dene.
    }
  }

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "${pharmacy.name} konumu acilamadi. Google Maps uygulamasini kontrol edin.",
      ),
    ),
  );
}

Future<void> _callPharmacy(BuildContext context, _PharmacyData pharmacy) async {
  final phoneUri = Uri(scheme: "tel", path: pharmacy.phone.replaceAll(" ", ""));

  try {
    final opened = await launchUrl(
      phoneUri,
      mode: LaunchMode.externalApplication,
    );
    if (opened) return;
  } catch (_) {}

  if (!context.mounted) return;

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text("${pharmacy.name} aranamadı.")));
}

// ---------------------------------------------------------------------------
// Ana sayfa widget'ı
// ---------------------------------------------------------------------------
class PharmacyMapPage extends StatefulWidget {
  final bool onlyDuty;

  const PharmacyMapPage({super.key, this.onlyDuty = false});

  @override
  State<PharmacyMapPage> createState() => _PharmacyMapPageState();
}

class _PharmacyMapPageState extends State<PharmacyMapPage> {
  late final MapController _mapController;
  late final TextEditingController _searchController;
  _PharmacyData? _selectedPharmacy;
  late List<_PharmacyData> _pharmacies;
  double _currentZoom = 14.5;
  bool _showMap = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _searchController = TextEditingController();
    _pharmacies = _pharmaciesFor(_kUserLocation);
    _selectedPharmacy = _pharmacies.firstOrNull;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // Seçilen eczaneye tam olarak uç — koordinatları doğrudan kullanıyoruz
  void _selectAndFly(_PharmacyData pharmacy) {
    setState(() {
      _selectedPharmacy = pharmacy;
      _currentZoom = 16.0;
      _showMap = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mapController.move(pharmacy.latLng, 16.0);
    });
  }

  void _zoomIn() {
    _currentZoom = (_currentZoom + 1).clamp(3.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
    setState(() {});
  }

  void _zoomOut() {
    _currentZoom = (_currentZoom - 1).clamp(3.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
    setState(() {});
  }

  void _goToMyLocation() {
    setState(() => _currentZoom = 14.5);
    _mapController.move(_kUserLocation, 14.5);
  }

  List<_PharmacyData> _pharmaciesFor(LatLng origin) {
    final pharmacies = widget.onlyDuty
        ? _kPharmacies.where((p) => p.isOnDuty).toList()
        : List<_PharmacyData>.from(_kPharmacies);

    pharmacies.sort(
      (a, b) =>
          a.distanceMetersFrom(origin).compareTo(b.distanceMetersFrom(origin)),
    );

    return pharmacies;
  }

  List<_PharmacyData> get _visiblePharmacies {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _pharmacies;

    return _pharmacies
        .where(
          (p) =>
              p.name.toLowerCase().contains(query) ||
              p.address.toLowerCase().contains(query) ||
              p.phone.contains(query),
        )
        .toList();
  }

  void _updateSearch(String value) {
    setState(() {
      _searchQuery = value;
      final visible = _visiblePharmacies;
      if (visible.isEmpty) {
        _selectedPharmacy = null;
      } else if (_selectedPharmacy == null ||
          !visible.contains(_selectedPharmacy)) {
        _selectedPharmacy = visible.first;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _updateSearch("");
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.onlyDuty ? "Nöbetçi Eczaneler" : "Yakındaki Eczaneler";
    final visiblePharmacies = _visiblePharmacies;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _SummaryBanner(
            onlyDuty: widget.onlyDuty,
            count: visiblePharmacies.length,
          ),
          const SizedBox(height: 12),
          _SearchField(
            controller: _searchController,
            onChanged: _updateSearch,
            onClear: _clearSearch,
          ),
          const SizedBox(height: 10),
          _ViewSwitch(
            showMap: _showMap,
            onChanged: (value) => setState(() => _showMap = value),
          ),
          const SizedBox(height: 12),

          if (_showMap) ...[
            _PharmacyMap(
              mapController: _mapController,
              currentZoom: _currentZoom,
              pharmacies: visiblePharmacies,
              selectedPharmacy: _selectedPharmacy,
              onMapMove: (zoom) => _currentZoom = zoom,
              onSelect: (pharmacy) {
                _selectAndFly(pharmacy);
                _showPharmacyBottomSheet(context, pharmacy);
              },
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onMyLocation: _goToMyLocation,
            ),
            const SizedBox(height: 8),
            const _MapLegend(),
            const SizedBox(height: 12),
            if (_selectedPharmacy != null)
              _SelectedPharmacyPanel(
                pharmacy: _selectedPharmacy!,
                distanceText: _selectedPharmacy!.distanceTextFrom(
                  _kUserLocation,
                ),
                onCall: () => _callPharmacy(context, _selectedPharmacy!),
                onNavigate: () =>
                    _openGoogleMapsNavigation(context, _selectedPharmacy!),
              ),
          ],

          const SizedBox(height: 16),
          Text(
            widget.onlyDuty
                ? "Bu gece açık olanlar"
                : "Konumuna en yakın eczaneler",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (visiblePharmacies.isEmpty)
            EmptyState(
              icon: Icons.search_off,
              title: "Sonuç bulunamadı",
              message:
                  "Eczane adı, mahalle veya telefon bilgisiyle tekrar ara.",
              action: TextButton.icon(
                onPressed: _clearSearch,
                icon: const Icon(Icons.close),
                label: const Text("Aramayı temizle"),
              ),
            )
          else
            ...visiblePharmacies.map(
              (pharmacy) => _PharmacyCard(
                pharmacy: pharmacy,
                selected: pharmacy == _selectedPharmacy,
                distanceText: pharmacy.distanceTextFrom(_kUserLocation),
                onTap: () => _selectAndFly(pharmacy),
                onCall: () => _callPharmacy(context, pharmacy),
                onNavigate: () => _openGoogleMapsNavigation(context, pharmacy),
              ),
            ),
        ],
      ),
    );
  }

  void _showPharmacyBottomSheet(BuildContext context, _PharmacyData pharmacy) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: pharmacy.isOnDuty
                        ? const Color(0xFFFFEEF0)
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    pharmacy.isOnDuty
                        ? Icons.nightlight_round
                        : Icons.local_pharmacy,
                    color: pharmacy.isOnDuty
                        ? Colors.redAccent
                        : AppColors.primaryDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pharmacy.isOnDuty ? "Nöbetçi" : "Açık",
                        style: TextStyle(
                          color: pharmacy.isOnDuty
                              ? Colors.redAccent
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    pharmacy.address,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 6),
                Text(
                  pharmacy.phone,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _callPharmacy(context, pharmacy),
                    icon: const Icon(Icons.phone),
                    label: const Text("Ara"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _openGoogleMapsNavigation(context, pharmacy),
                    icon: const Icon(Icons.navigation),
                    label: const Text("Yol Tarifi"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: "Eczane, mahalle veya telefon ara",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              tooltip: "Aramayı temizle",
              onPressed: onClear,
              icon: const Icon(Icons.close),
            );
          },
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}

class _ViewSwitch extends StatelessWidget {
  final bool showMap;
  final ValueChanged<bool> onChanged;

  const _ViewSwitch({required this.showMap, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(
          value: true,
          icon: Icon(Icons.map_outlined),
          label: Text("Harita"),
        ),
        ButtonSegment(
          value: false,
          icon: Icon(Icons.format_list_bulleted),
          label: Text("Liste"),
        ),
      ],
      selected: {showMap},
      onSelectionChanged: (values) => onChanged(values.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryLight
              : Colors.white,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryDark
              : AppColors.navy,
        ),
      ),
    );
  }
}

class _PharmacyMap extends StatelessWidget {
  final MapController mapController;
  final double currentZoom;
  final List<_PharmacyData> pharmacies;
  final _PharmacyData? selectedPharmacy;
  final ValueChanged<double> onMapMove;
  final ValueChanged<_PharmacyData> onSelect;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocation;

  const _PharmacyMap({
    required this.mapController,
    required this.currentZoom,
    required this.pharmacies,
    required this.selectedPharmacy,
    required this.onMapMove,
    required this.onSelect,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _kUserLocation,
                initialZoom: currentZoom,
                onMapEvent: (event) {
                  if (event is MapEventMove) {
                    onMapMove(event.camera.zoom);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: "com.example.ilac_getir",
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _kUserLocation,
                      width: 54,
                      height: 54,
                      child: const _UserLocationMarker(),
                    ),
                    ...pharmacies.map(
                      (p) => Marker(
                        point: p.latLng,
                        width: 46,
                        height: 46,
                        child: GestureDetector(
                          onTap: () => onSelect(p),
                          child: _PharmacyMarker(
                            isOnDuty: p.isOnDuty,
                            isSelected: selectedPharmacy == p,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 10,
              top: 10,
              child: _MapCountChip(count: pharmacies.length),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Column(
                children: [
                  _MapControlButton(
                    icon: Icons.add,
                    onTap: onZoomIn,
                    tooltip: "Yakınlaştır",
                  ),
                  const SizedBox(height: 6),
                  _MapControlButton(
                    icon: Icons.remove,
                    onTap: onZoomOut,
                    tooltip: "Uzaklaştır",
                  ),
                  const SizedBox(height: 6),
                  _MapControlButton(
                    icon: Icons.my_location,
                    onTap: onMyLocation,
                    tooltip: "Konumuma git",
                    color: AppColors.accent,
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

class _MapCountChip extends StatelessWidget {
  final int count;

  const _MapCountChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        "$count sonuç",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MapLegend extends StatelessWidget {
  const _MapLegend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _LegendDot(color: AppColors.primary),
        SizedBox(width: 6),
        Text("Normal", style: TextStyle(fontSize: 12)),
        SizedBox(width: 16),
        _LegendDot(color: Colors.redAccent),
        SizedBox(width: 6),
        Text("Nöbetçi", style: TextStyle(fontSize: 12)),
        SizedBox(width: 16),
        _LegendDot(color: AppColors.accent),
        SizedBox(width: 6),
        Text("Konumun", style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _SelectedPharmacyPanel extends StatelessWidget {
  final _PharmacyData pharmacy;
  final String distanceText;
  final VoidCallback onCall;
  final VoidCallback onNavigate;

  const _SelectedPharmacyPanel({
    required this.pharmacy,
    required this.distanceText,
    required this.onCall,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: [
          Icon(
            pharmacy.isOnDuty ? Icons.nightlight_round : Icons.local_pharmacy,
            color: pharmacy.isOnDuty ? Colors.redAccent : AppColors.primaryDark,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pharmacy.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  "$distanceText uzaklıkta • ${pharmacy.isOnDuty ? "Nöbetçi" : "Açık"}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: "Ara",
            onPressed: onCall,
            icon: const Icon(Icons.phone_outlined),
          ),
          IconButton(
            tooltip: "Yol tarifi al",
            onPressed: onNavigate,
            icon: const Icon(Icons.navigation_outlined),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Harita kontrol butonu (zoom +/-  ve konum)
// ---------------------------------------------------------------------------
class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color? color;

  const _MapControlButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: color ?? AppColors.navy),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Özet banner
// ---------------------------------------------------------------------------
class _SummaryBanner extends StatelessWidget {
  final bool onlyDuty;
  final int count;

  const _SummaryBanner({required this.onlyDuty, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              onlyDuty ? Icons.nightlight_round : Icons.my_location,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$count eczane bulundu",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Konum: $_kUserAddress",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.22),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PharmacyMarker extends StatelessWidget {
  final bool isOnDuty;
  final bool isSelected;

  const _PharmacyMarker({required this.isOnDuty, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = isOnDuty ? Colors.redAccent : AppColors.primary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Icon(
        Icons.location_on,
        color: color,
        size: isSelected ? 46 : 36,
        shadows: [Shadow(color: color.withValues(alpha: 0.4), blurRadius: 8)],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  final _PharmacyData pharmacy;
  final bool selected;
  final String distanceText;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onNavigate;

  const _PharmacyCard({
    required this.pharmacy,
    required this.selected,
    required this.distanceText,
    required this.onTap,
    required this.onCall,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : Colors.grey.shade200,
          width: selected ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: pharmacy.isOnDuty
                      ? const Color(0xFFFFEEF0)
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  pharmacy.isOnDuty
                      ? Icons.nightlight_round
                      : Icons.local_pharmacy,
                  color: pharmacy.isOnDuty
                      ? Colors.redAccent
                      : AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pharmacy.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: pharmacy.isOnDuty
                                ? const Color(0xFFFFEEF0)
                                : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            pharmacy.isOnDuty ? "Nöbetçi" : "Açık",
                            style: TextStyle(
                              color: pharmacy.isOnDuty
                                  ? Colors.redAccent
                                  : AppColors.primaryDark,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pharmacy.address,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.near_me_outlined,
                          size: 14,
                          color: AppColors.primaryDark,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          distanceText,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: AppColors.primaryDark,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            pharmacy.phone,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  _CardActionButton(
                    icon: Icons.phone_outlined,
                    color: AppColors.primaryDark,
                    tooltip: "Ara",
                    onTap: onCall,
                  ),
                  const SizedBox(height: 6),
                  _CardActionButton(
                    icon: Icons.navigation,
                    color: AppColors.primary,
                    tooltip: "Yol tarifi al",
                    onTap: onNavigate,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _CardActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 19),
        ),
      ),
    );
  }
}
