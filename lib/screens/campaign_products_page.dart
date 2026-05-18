import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/medicine_data.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';
import 'medicine_detail_page.dart';

class CampaignProductsPage extends StatefulWidget {
  final Map<String, dynamic> campaign;

  const CampaignProductsPage({super.key, required this.campaign});

  @override
  State<CampaignProductsPage> createState() => _CampaignProductsPageState();
}

enum _CampaignViewMode { suggested, bestDeal, fastest, favorites }

class _CampaignProductsPageState extends State<CampaignProductsPage> {
  _CampaignViewMode _viewMode = _CampaignViewMode.suggested;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteModel>();
    final user = context.read<UserModel>();
    final userId = user.phone.isNotEmpty ? user.phone : "guest_${user.name}";
    final products = _visibleProducts(
      _campaignProducts(widget.campaign["type"] as String),
      favorites,
      userId,
    );
    final gradient = (widget.campaign["gradient"] as List).cast<Color>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(widget.campaign["title"] as String)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          _CampaignHeader(
            campaign: widget.campaign,
            productCount: products.length,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.verified_outlined,
                text: _campaignInfo(widget.campaign["type"] as String),
              ),
              _InfoChip(
                icon: Icons.inventory_2_outlined,
                text: "${products.length} ürün",
              ),
            ],
          ),
          const SizedBox(height: 12),
          _CampaignModeChips(
            selectedMode: _viewMode,
            onSelected: (mode) => setState(() => _viewMode = mode),
          ),
          const SizedBox(height: 14),
          if (products.isEmpty)
            _EmptyCampaignMessage(
              message: _viewMode == _CampaignViewMode.favorites
                  ? "Bu kampanyada favori ürünün yok."
                  : "Bu kampanyada şu an ürün bulunamadı.",
            )
          else
            ...products.map(
              (product) =>
                  _CampaignProductCard(product: product, gradient: gradient),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _visibleProducts(
    List<Map<String, dynamic>> products,
    FavoriteModel favorites,
    String userId,
  ) {
    final visible = List<Map<String, dynamic>>.from(products);

    switch (_viewMode) {
      case _CampaignViewMode.suggested:
        return visible;
      case _CampaignViewMode.bestDeal:
        visible.sort((a, b) {
          final aDiscount = a["discountPercent"] as int? ?? 0;
          final bDiscount = b["discountPercent"] as int? ?? 0;
          final discountCompare = bDiscount.compareTo(aDiscount);
          if (discountCompare != 0) return discountCompare;

          final aPrice = a["price"] as double;
          final bPrice = b["price"] as double;
          final aOriginalPrice = (a["originalPrice"] as double?) ?? aPrice;
          final bOriginalPrice = (b["originalPrice"] as double?) ?? bPrice;
          final aSaving = aOriginalPrice - aPrice;
          final bSaving = bOriginalPrice - bPrice;
          return bSaving.compareTo(aSaving);
        });
        return visible;
      case _CampaignViewMode.fastest:
        visible.sort((a, b) {
          final aMinutes = a["deliveryMinutes"] as int? ?? 999;
          final bMinutes = b["deliveryMinutes"] as int? ?? 999;
          return aMinutes.compareTo(bMinutes);
        });
        return visible;
      case _CampaignViewMode.favorites:
        return visible
            .where(
              (product) =>
                  favorites.isFavorite(product["name"] as String, userId),
            )
            .toList();
    }
  }

  static String _campaignInfo(String type) {
    switch (type) {
      case "fast_delivery":
        return "18-35 dk teslimat";
      case "discounts":
        return "%15-%50 indirim";
      case "dermo":
        return "Dermokozmetik seçkisi";
      default:
        return "Kampanya";
    }
  }

  static List<Map<String, dynamic>> _campaignProducts(String type) {
    switch (type) {
      case "fast_delivery":
        final fastTypes = {"agri", "vitamin", "soguk", "mide"};
        return medicines
            .where((item) => fastTypes.contains(item["type"]))
            .take(16)
            .toList()
            .asMap()
            .entries
            .map((entry) {
              final minutes = 18 + (entry.key % 6) * 3;
              return {
                ...entry.value,
                "deliveryMinutes": minutes,
                "campaignLabel": "$minutes dk",
              };
            })
            .toList();
      case "discounts":
        final discountPercents = [
          15,
          18,
          20,
          22,
          25,
          28,
          30,
          32,
          35,
          38,
          40,
          42,
          45,
          48,
          50,
          24,
          34,
          44,
        ];
        final selected = [
          ...medicines.where((item) => item["isAffordable"] == true),
          ...medicines.where((item) => item["type"] != "dermokozmetik"),
        ].take(18).toList();

        return selected.asMap().entries.map((entry) {
          final discount =
              discountPercents[entry.key % discountPercents.length];
          final originalPrice = entry.value["price"] as double;
          final discountedPrice = originalPrice * (100 - discount) / 100;
          return {
            ...entry.value,
            "originalPrice": originalPrice,
            "price": double.parse(discountedPrice.toStringAsFixed(2)),
            "discountPercent": discount,
            "campaignLabel": "%$discount",
          };
        }).toList();
      case "dermo":
        return medicines
            .where((item) => item["type"] == "dermokozmetik")
            .toList()
            .asMap()
            .entries
            .map((entry) {
              final label =
                  entry.value["tag"] ?? (entry.key.isEven ? "Popüler" : "Yeni");
              return {...entry.value, "campaignLabel": label};
            })
            .toList();
      default:
        return medicines.take(12).toList();
    }
  }
}

class _CampaignHeader extends StatelessWidget {
  final Map<String, dynamic> campaign;
  final int productCount;

  const _CampaignHeader({required this.campaign, required this.productCount});

  @override
  Widget build(BuildContext context) {
    final gradient = (campaign["gradient"] as List).cast<Color>();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign["title"] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  campaign["text"] as String,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "$productCount seçili ürün listelendi",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              campaign["icon"] as IconData,
              color: Colors.white,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryDark),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _CampaignModeChips extends StatelessWidget {
  final _CampaignViewMode selectedMode;
  final ValueChanged<_CampaignViewMode> onSelected;

  const _CampaignModeChips({
    required this.selectedMode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const modes = [
      (mode: _CampaignViewMode.suggested, label: "Önerilen"),
      (mode: _CampaignViewMode.bestDeal, label: "En avantajlı"),
      (mode: _CampaignViewMode.fastest, label: "En hızlı"),
      (mode: _CampaignViewMode.favorites, label: "Favoriler"),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: modes.map((item) {
          final selected = selectedMode == item.mode;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(item.label),
              selected: selected,
              onSelected: (_) => onSelected(item.mode),
              showCheckmark: false,
              avatar: selected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
              selectedColor: AppColors.primaryDark,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: selected
                    ? AppColors.primaryDark
                    : AppColors.primaryLight,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CampaignProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final List<Color> gradient;

  const _CampaignProductCard({required this.product, required this.gradient});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<Cart>();
    final favorites = context.watch<FavoriteModel>();
    final user = context.read<UserModel>();
    final userId = user.phone.isNotEmpty ? user.phone : "guest_${user.name}";
    final productName = product["name"] as String;
    final isFavorite = favorites.isFavorite(productName, userId);
    final price = product["price"] as double;
    final originalPrice = product["originalPrice"] as double?;
    final saving = originalPrice == null ? null : originalPrice - price;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MedicineDetailPage(ilac: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 86,
                    height: 92,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      product["image"] as String,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.medication,
                          size: 42,
                          color: AppColors.primaryDark,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 6,
                    top: 6,
                    child: _Badge(
                      text: product["campaignLabel"].toString(),
                      gradient: gradient,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product["description"] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "${price.toStringAsFixed(2)} TL",
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (originalPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            "${originalPrice.toStringAsFixed(2)} TL",
                            style: const TextStyle(
                              color: Colors.black45,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (saving != null && saving > 0) ...[
                      const SizedBox(height: 5),
                      _SavingInfo(amount: saving),
                    ],
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              cart.addItem(
                                productName,
                                price,
                                originalPrice: originalPrice,
                                discountPercent:
                                    product["discountPercent"] as int?,
                                campaignLabel:
                                    product["campaignLabel"] as String?,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$productName sepete eklendi"),
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: "Sepete git",
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/sepet");
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_shopping_cart, size: 16),
                            label: const Text("Ekle"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: isFavorite
                                ? Colors.red.withValues(alpha: 0.08)
                                : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            tooltip: "Favori",
                            onPressed: () {
                              favorites.toggleFavorite(productName, userId);
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : AppColors.navy,
                            ),
                          ),
                        ),
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

class _EmptyCampaignMessage extends StatelessWidget {
  final String message;

  const _EmptyCampaignMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_offer_outlined,
            color: AppColors.primaryDark,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SavingInfo extends StatelessWidget {
  final double amount;

  const _SavingInfo({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.savings_outlined, size: 15, color: Colors.green),
          const SizedBox(width: 5),
          Text(
            "Kazancınız ${amount.toStringAsFixed(2)} TL",
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final List<Color> gradient;

  const _Badge({required this.text, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
