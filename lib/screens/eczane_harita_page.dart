import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_colors.dart';

class EczaneHaritaPage extends StatefulWidget {
  final bool sadeceNobetci;

  const EczaneHaritaPage({super.key, this.sadeceNobetci = false});

  @override
  State<EczaneHaritaPage> createState() => _EczaneHaritaPageState();
}

class _EczaneHaritaPageState extends State<EczaneHaritaPage> {
  Position? _currentPosition;
  List<_Pharmacy> _pharmacies = [];
  _Pharmacy? _selectedPharmacy;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLocationAndPharmacies();
  }

  Future<void> _loadLocationAndPharmacies() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _loading = false;
        _errorMessage = "Konum servisi kapalı. Eczaneleri görebilmek için konumu açmalısın.";
      });
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      setState(() {
        _loading = false;
        _errorMessage = "Konum izni verilmedi. Yakındaki eczaneleri listelemek için izin gerekli.";
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _loading = false;
        _errorMessage = "Konum izni kalıcı olarak kapatılmış. Ayarlardan izin vermen gerekiyor.";
      });
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final pharmacies = _buildPharmacies(position);

    setState(() {
      _currentPosition = position;
      _pharmacies = widget.sadeceNobetci
          ? pharmacies.where((pharmacy) => pharmacy.isOnDuty).toList()
          : pharmacies;
      _selectedPharmacy = _pharmacies.firstOrNull;
      _loading = false;
    });
  }

  List<_Pharmacy> _buildPharmacies(Position position) {
    final templates = [
      _PharmacyTemplate("Şifa Eczanesi", "Atatürk Mah. 123. Sokak No:5", 0.0045, 0.0032, true),
      _PharmacyTemplate("Güneş Eczanesi", "Cumhuriyet Cad. No:45", -0.0030, 0.0025, false),
      _PharmacyTemplate("Merkez Eczanesi", "İstasyon Meydanı No:12", 0.0020, -0.0040, true),
      _PharmacyTemplate("Hayat Eczanesi", "Sağlık Sok. No:8", -0.0042, -0.0020, false),
      _PharmacyTemplate("Dvita Eczanesi", "Papatya Cad. No:18", 0.0060, -0.0015, true),
      _PharmacyTemplate("Yeni Eczane", "Barış Mah. Çınar Sok. No:7", -0.0018, 0.0050, false),
      _PharmacyTemplate("Can Eczanesi", "Okul Cad. No:31", 0.0010, 0.0062, true),
      _PharmacyTemplate("Sağlık Eczanesi", "Lale Sok. No:11", -0.0055, 0.0040, false),
      _PharmacyTemplate("Umut Eczanesi", "Mimar Sinan Cad. No:20", 0.0035, -0.0060, true),
      _PharmacyTemplate("Park Eczanesi", "Park Yolu No:3", -0.0060, -0.0048, false),
      _PharmacyTemplate("Çınar Eczanesi", "Bahçeşehir Cad. No:16", 0.0070, 0.0045, false),
      _PharmacyTemplate("Gece Şifa Eczanesi", "Nöbetçi Sok. No:2", -0.0025, -0.0065, true),
    ];

    final pharmacies = templates.map((template) {
      final latitude = position.latitude + template.latitudeOffset;
      final longitude = position.longitude + template.longitudeOffset;
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        latitude,
        longitude,
      );

      return _Pharmacy(
        name: template.name,
        address: template.address,
        latitude: latitude,
        longitude: longitude,
        latitudeOffset: template.latitudeOffset,
        longitudeOffset: template.longitudeOffset,
        distanceMeters: distance.round(),
        isOnDuty: template.isOnDuty,
        phone: "0 212 ${300 + distance.round() % 500} ${10 + distance.round() % 80} ${20 + distance.round() % 70}",
      );
    }).toList();

    pharmacies.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return pharmacies;
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.sadeceNobetci ? "Nöbetçi Eczaneler" : "Yakındaki Eczaneler";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _LocationError(message: _errorMessage!, onRetry: _loadLocationAndPharmacies)
          : RefreshIndicator(
              onRefresh: _loadLocationAndPharmacies,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                children: [
                  _MapSummary(
                    onlyDuty: widget.sadeceNobetci,
                    pharmacyCount: _pharmacies.length,
                    position: _currentPosition!,
                  ),
                  const SizedBox(height: 12),
                  _MapPreview(
                    pharmacies: _pharmacies,
                    selectedPharmacy: _selectedPharmacy,
                    onSelected: (pharmacy) {
                      setState(() => _selectedPharmacy = pharmacy);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.sadeceNobetci ? "Bu gece açık olanlar" : "Konumuna en yakın eczaneler",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._pharmacies.map(
                    (pharmacy) => _PharmacyCard(
                      pharmacy: pharmacy,
                      selected: pharmacy == _selectedPharmacy,
                      onTap: () => setState(() => _selectedPharmacy = pharmacy),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _MapSummary extends StatelessWidget {
  final bool onlyDuty;
  final int pharmacyCount;
  final Position position;

  const _MapSummary({
    required this.onlyDuty,
    required this.pharmacyCount,
    required this.position,
  });

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
                  "$pharmacyCount eczane bulundu",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  onlyDuty
                      ? "Konumuna göre nöbetçi eczaneler listeleniyor."
                      : "Konumuna göre yakın eczaneler listeleniyor.",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  final List<_Pharmacy> pharmacies;
  final _Pharmacy? selectedPharmacy;
  final ValueChanged<_Pharmacy> onSelected;

  const _MapPreview({
    required this.pharmacies,
    required this.selectedPharmacy,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 285,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3EE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MapBackgroundPainter())),
          const Align(
            alignment: Alignment.center,
            child: _CurrentLocationMarker(),
          ),
          ...pharmacies.map((pharmacy) {
            final alignment = Alignment(
              (pharmacy.longitudeOffset * 120).clamp(-0.88, 0.88),
              (pharmacy.latitudeOffset * -120).clamp(-0.82, 0.82),
            );
            final selected = pharmacy == selectedPharmacy;

            return Align(
              alignment: alignment,
              child: GestureDetector(
                onTap: () => onSelected(pharmacy),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: selected ? 42 : 34,
                  height: selected ? 42 : 34,
                  decoration: BoxDecoration(
                    color: pharmacy.isOnDuty ? Colors.redAccent : AppColors.primaryDark,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
                    ],
                  ),
                  child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 19),
                ),
              ),
            );
          }),
          if (selectedPharmacy != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedPharmacy!.isOnDuty ? Icons.nightlight_round : Icons.local_pharmacy,
                      color: selectedPharmacy!.isOnDuty ? Colors.redAccent : AppColors.primaryDark,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedPharmacy!.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${selectedPharmacy!.distanceText} • ${selectedPharmacy!.statusText}",
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  final _Pharmacy pharmacy;
  final bool selected;
  final VoidCallback onTap;

  const _PharmacyCard({
    required this.pharmacy,
    required this.selected,
    required this.onTap,
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
          width: selected ? 1.4 : 1,
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
                  color: pharmacy.isOnDuty ? const Color(0xFFFFEEF0) : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  pharmacy.isOnDuty ? Icons.nightlight_round : Icons.local_pharmacy,
                  color: pharmacy.isOnDuty ? Colors.redAccent : AppColors.primaryDark,
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
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _StatusPill(pharmacy: pharmacy),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(pharmacy.address, style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(Icons.near_me_outlined, size: 16, color: AppColors.primaryDark),
                        const SizedBox(width: 4),
                        Text(pharmacy.distanceText),
                        const SizedBox(width: 12),
                        const Icon(Icons.phone_outlined, size: 16, color: AppColors.primaryDark),
                        const SizedBox(width: 4),
                        Expanded(child: Text(pharmacy.phone, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final _Pharmacy pharmacy;

  const _StatusPill({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: pharmacy.isOnDuty ? const Color(0xFFFFEEF0) : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        pharmacy.isOnDuty ? "Nöbetçi" : "Açık",
        style: TextStyle(
          color: pharmacy.isOnDuty ? Colors.redAccent : AppColors.primaryDark,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LocationError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LocationError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off_outlined, size: 72, color: AppColors.primaryDark),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Tekrar dene"),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentLocationMarker extends StatelessWidget {
  const _CurrentLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.18),
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
          ),
        ),
      ),
    );
  }
}

class _MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.82)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    final thinRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.62)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final parkPaint = Paint()..color = const Color(0xFFD6ECDD);

    canvas.drawCircle(Offset(size.width * 0.20, size.height * 0.20), 58, parkPaint);
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.28), 46, parkPaint);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.78), 64, parkPaint);

    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.72),
      Offset(size.width * 0.92, size.height * 0.28),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.05),
      Offset(size.width * 0.66, size.height * 0.94),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.04, size.height * 0.35),
      Offset(size.width * 0.94, size.height * 0.52),
      thinRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.36, size.height * 0.04),
      Offset(size.width * 0.94, size.height * 0.86),
      thinRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PharmacyTemplate {
  final String name;
  final String address;
  final double latitudeOffset;
  final double longitudeOffset;
  final bool isOnDuty;

  const _PharmacyTemplate(
    this.name,
    this.address,
    this.latitudeOffset,
    this.longitudeOffset,
    this.isOnDuty,
  );
}

class _Pharmacy {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double latitudeOffset;
  final double longitudeOffset;
  final int distanceMeters;
  final bool isOnDuty;
  final String phone;

  const _Pharmacy({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.latitudeOffset,
    required this.longitudeOffset,
    required this.distanceMeters,
    required this.isOnDuty,
    required this.phone,
  });

  String get distanceText {
    if (distanceMeters >= 1000) {
      return "${(distanceMeters / 1000).toStringAsFixed(1)} km";
    }
    return "$distanceMeters m";
  }

  String get statusText => isOnDuty ? "Gece açık" : "Gündüz açık";
}
