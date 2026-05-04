import 'package:flutter/material.dart';

final List<Map<String, dynamic>> medicineCategories = [
  {"name": "Ağrı Kesici", "type": "agri", "color": Colors.red, "icon": Icons.healing},
  {"name": "Vitamin", "type": "vitamin", "color": Colors.orange, "icon": Icons.local_pharmacy},
  {"name": "Soğuk Algınlığı", "type": "soguk", "color": Colors.blue, "icon": Icons.ac_unit},
  {"name": "Kas Gevşetici", "type": "kas", "color": Colors.pink, "icon": Icons.accessibility_new},
  {"name": "Mide", "type": "mide", "color": Colors.green, "icon": Icons.medication},
  {"name": "Diğer", "type": "diger", "color": Colors.purple, "icon": Icons.more_horiz},
];

final List<Map<String, dynamic>> medicines = [
  {
    "name": "Parol",
    "price": 50.0,
    "type": "agri",
    "description": "Ağrı kesici ve ateş düşürücü olarak bilinen örnek bir üründür.",
  },
  {
    "name": "Dolven",
    "price": 60.0,
    "type": "agri",
    "description": "Ağrı, ateş ve iltihap şikayetlerinde kullanılan örnek bir üründür.",
  },
  {
    "name": "Arveles",
    "price": 80.0,
    "type": "agri",
    "description": "Hızlı etki gösteren ağrı kesici kategorisinde örnek bir üründür.",
  },
  {
    "name": "Majezik",
    "price": 70.0,
    "type": "agri",
    "description": "Boğaz, kas ve diş ağrısı gibi durumlarda bilinen örnek bir üründür.",
  },
  {
    "name": "Ocean",
    "price": 70.0,
    "type": "vitamin",
    "description": "Günlük vitamin desteği için listelenmiş örnek bir takviyedir.",
  },
  {
    "name": "Solgar B12",
    "price": 200.0,
    "type": "vitamin",
    "description": "B12 vitamini desteği için örnek bir takviye ürünüdür.",
  },
  {
    "name": "Supradyn",
    "price": 300.0,
    "type": "vitamin",
    "description": "Günlük vitamin ve mineral desteği için örnek bir üründür.",
  },
  {
    "name": "Kiperin",
    "price": 500.0,
    "type": "vitamin",
    "description": "Bağışıklık desteği alanında listelenmiş örnek bir takviyedir.",
  },
  {
    "name": "Rennie",
    "price": 150.0,
    "type": "mide",
    "description": "Mide yanması ve hazımsızlık alanında örnek bir üründür.",
  },
  {
    "name": "Gaviscon",
    "price": 180.0,
    "type": "mide",
    "description": "Reflü ve mide yanması için listelenmiş örnek bir üründür.",
  },
  {
    "name": "Lansor",
    "price": 220.0,
    "type": "mide",
    "description": "Mide asidi şikayetlerinde bilinen örnek bir üründür.",
  },
  {
    "name": "Omeprazol",
    "price": 240.0,
    "type": "mide",
    "description": "Mide asidi azaltma alanında örnek bir üründür.",
  },
  {
    "name": "Parafon",
    "price": 90.0,
    "type": "kas",
    "description": "Kas spazmı ve kas ağrısı alanında örnek bir üründür.",
  },
  {
    "name": "Cabral",
    "price": 240.0,
    "type": "kas",
    "description": "Kas gevşetici kategorisinde örnek bir üründür.",
  },
  {
    "name": "Lioresal",
    "price": 240.0,
    "type": "kas",
    "description": "Kas sertliği için listelenmiş örnek bir üründür.",
  },
  {
    "name": "Tizanidin",
    "price": 240.0,
    "type": "kas",
    "description": "Kas gevşetici kategorisinde örnek bir üründür.",
  },
  {
    "name": "Aferin",
    "price": 170.0,
    "type": "soguk",
    "description": "Soğuk algınlığı belirtileri için örnek bir üründür.",
  },
  {
    "name": "Tylol Hot",
    "price": 40.0,
    "type": "soguk",
    "description": "Grip ve soğuk algınlığı alanında örnek bir üründür.",
  },
  {
    "name": "Gripin",
    "price": 60.0,
    "type": "soguk",
    "description": "Soğuk algınlığı kategorisinde örnek bir üründür.",
  },
  {
    "name": "İbuCold",
    "price": 130.0,
    "type": "soguk",
    "description": "Burun akıntısı ve halsizlik gibi belirtiler için örnek üründür.",
  },
];

String categoryTitle(String type) {
  final category = medicineCategories.firstWhere(
    (item) => item["type"] == type,
    orElse: () => medicineCategories.last,
  );

  return category["name"];
}
