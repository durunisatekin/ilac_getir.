import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Sabit başlangıç konumu: Ümraniye - İstiklal Mahallesi
// ---------------------------------------------------------------------------
const LatLng _kUserLocation = LatLng(41.02560, 29.09630);
const String _kUserAddress = "İstiklal Mah., Ümraniye / İstanbul";

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
Future<void> _openGoogleMapsNavigation(double lat, double lng) async {
  final appUri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  final webUri = Uri.parse(
    "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving",
  );

  if (await canLaunchUrl(appUri)) {
    await launchUrl(appUri);
  } else {
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }
}

// ---------------------------------------------------------------------------
// Ana sayfa widget'ı
// ---------------------------------------------------------------------------
class EczaneHaritaPage extends StatefulWidget {
  final bool sadeceNobetci;

  const EczaneHaritaPage({super.key, this.sadeceNobetci = false});

  @override
  State<EczaneHaritaPage> createState() => _EczaneHaritaPageState();
}

class _EczaneHaritaPageState extends State<EczaneHaritaPage> {
  late final MapController _mapController;
  _PharmacyData? _selectedPharmacy;
  late final List<_PharmacyData> _pharmacies;
  double _currentZoom = 14.5;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pharmacies = widget.sadeceNobetci
        ? _kPharmacies.where((p) => p.isOnDuty).toList()
        : (List.from(_kPharmacies)..sort(
            (a, b) => a
                .distanceMetersFrom(_kUserLocation)
                .compareTo(b.distanceMetersFrom(_kUserLocation)),
          ));
    _selectedPharmacy = _pharmacies.firstOrNull;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // Seçilen eczaneye tam olarak uç — koordinatları doğrudan kullanıyoruz
  void _selectAndFly(_PharmacyData pharmacy) {
    setState(() {
      _selectedPharmacy = pharmacy;
      _currentZoom = 16.0;
    });
    _mapController.move(LatLng(pharmacy.lat, pharmacy.lng), 16.0);
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

  @override
  Widget build(BuildContext context) {
    final title = widget.sadeceNobetci
        ? "Nöbetçi Eczaneler"
        : "Yakındaki Eczaneler";

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
            onlyDuty: widget.sadeceNobetci,
            count: _pharmacies.length,
          ),
          const SizedBox(height: 12),

          // Harita
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 285,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _kUserLocation,
                      initialZoom: _currentZoom,
                      onMapEvent: (event) {
                        if (event is MapEventMove) {
                          _currentZoom = event.camera.zoom;
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: "com.example.ilac_getir",
                      ),
                      MarkerLayer(
                        markers: [
                          // Kullanıcı konumu marker'ı
                          Marker(
                            point: _kUserLocation,
                            width: 54,
                            height: 54,
                            child: const _UserLocationMarker(),
                          ),
                          // Eczane marker'ları — her birinin koordinatı doğrudan kullanılıyor
                          ..._pharmacies.map(
                            (p) => Marker(
                              point: LatLng(p.lat, p.lng),
                              width: 46,
                              height: 46,
                              child: GestureDetector(
                                onTap: () {
                                  _selectAndFly(p);
                                  _showPharmacyBottomSheet(context, p);
                                },
                                child: _PharmacyMarker(
                                  isOnDuty: p.isOnDuty,
                                  isSelected: _selectedPharmacy == p,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Zoom & konum kontrol butonları (sağ alt köşe)
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Column(
                      children: [
                        _MapControlButton(
                          icon: Icons.add,
                          onTap: _zoomIn,
                          tooltip: "Yakınlaştır",
                        ),
                        const SizedBox(height: 6),
                        _MapControlButton(
                          icon: Icons.remove,
                          onTap: _zoomOut,
                          tooltip: "Uzaklaştır",
                        ),
                        const SizedBox(height: 6),
                        _MapControlButton(
                          icon: Icons.my_location,
                          onTap: _goToMyLocation,
                          tooltip: "Konumuma git",
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Harita açıklaması
          Row(
            children: [
              _LegendDot(color: AppColors.primary),
              const SizedBox(width: 6),
              const Text("Normal", style: TextStyle(fontSize: 12)),
              const SizedBox(width: 16),
              _LegendDot(color: Colors.redAccent),
              const SizedBox(width: 6),
              const Text("Nöbetçi", style: TextStyle(fontSize: 12)),
              const SizedBox(width: 16),
              _LegendDot(color: AppColors.accent),
              const SizedBox(width: 6),
              const Text("Konumun", style: TextStyle(fontSize: 12)),
            ],
          ),

          const SizedBox(height: 16),
          Text(
            widget.sadeceNobetci
                ? "Bu gece açık olanlar"
                : "Konumuna en yakın eczaneler",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ..._pharmacies.map(
            (pharmacy) => _PharmacyCard(
              pharmacy: pharmacy,
              selected: pharmacy == _selectedPharmacy,
              distanceText: pharmacy.distanceTextFrom(_kUserLocation),
              onTap: () => _selectAndFly(pharmacy),
              onNavigate: () =>
                  _openGoogleMapsNavigation(pharmacy.lat, pharmacy.lng),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    _openGoogleMapsNavigation(pharmacy.lat, pharmacy.lng),
                icon: const Icon(Icons.navigation),
                label: const Text("Yol Tarifi Al"),
              ),
            ),
          ],
        ),
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
  final VoidCallback onNavigate;

  const _PharmacyCard({
    required this.pharmacy,
    required this.selected,
    required this.distanceText,
    required this.onTap,
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
              GestureDetector(
                onTap: onNavigate,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.navigation,
                    color: Colors.white,
                    size: 20,
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
