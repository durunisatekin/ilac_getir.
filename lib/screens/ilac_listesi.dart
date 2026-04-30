import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ilac_detay_page.dart';
import '../models/cart_model.dart';
import '../theme/app_colors.dart';

class IlacListesi extends StatefulWidget {
  final String kategori;

  const IlacListesi({super.key, required this.kategori});

  @override
  State<IlacListesi> createState() => _IlacListesiState();
}

class _IlacListesiState extends State<IlacListesi> {
  String search = "";

  // Bu fonksiyon kategori kodunu kullanıcıya görünen başlığa çevirir.
  // Örnek: "agri" kodu ekranda "Ağrı Kesici" olarak görünür.
  String kategoriBasligi() {
    if (widget.kategori == "agri") {
      return "Ağrı Kesici";
    } else if (widget.kategori == "vitamin") {
      return "Vitamin";
    } else if (widget.kategori == "soguk") {
      return "Soğuk Algınlığı";
    } else if (widget.kategori == "kas") {
      return "Kas Gevşetici";
    } else if (widget.kategori == "mide") {
      return "Mide";
    } else {
      return "Diğer";
    }
  }

  final List<Map<String, dynamic>> tumIlaclar = [
    {
      "name": "Parol",
      "price": 50.0,
      "type": "agri",
      "description":
          "Ağrı kesici ve ateş düşürücü etkisiyle baş ağrısı, diş ağrısı, kas ağrıları ve ateşli durumların hafifletilmesinde kullanılır. Kullanım miktarı yaşa ve ihtiyaca göre değişebileceğinden, prospektüs bilgilerine veya uzman önerisine uygun şekilde tüketilmesi tavsiye edilir.",
    },
    {
      "name": "Dolven",
      "price": 60.0,
      "type": "agri",
      "description":
          "Ağrı, ateş ve iltihap kaynaklı şikâyetlerin hafifletilmesinde kullanılan bu ilaç; baş ağrısı, diş ağrısı ve kas-eklem ağrılarında etkili olabilir. Önerilen kullanım şekli için yaşa uygun doz dikkate alınmalı ve prospektüs ya da uzman tavsiyesine göre kullanılmalıdır.",
    },
    {
      "name": "Arveles",
      "price": 80.0,
      "type": "agri",
      "description":
          "Hızlı etki gösteren ağrı kesici özelliğiyle baş ağrısı, diş ağrısı, kas ağrıları ve çeşitli akut ağrıların hafifletilmesinde kullanılır. Kullanım dozu ve sıklığı için prospektüs bilgileri veya uzman önerisi doğrultusunda hareket edilmesi tavsiye edilir.",
    },
    {
      "name": "Majezik",
      "price": 70.0,
      "type": "agri",
      "description":
          "Ağrı ve iltihap kaynaklı şikâyetlerin giderilmesinde kullanılan bu ilaç; boğaz ağrısı, kas-eklem ağrıları ve diş ağrısı gibi durumlarda rahatlama sağlayabilir. Kullanım şekli için önerilen doz dikkate alınmalı ve prospektüs ya da uzman tavsiyesine uygun hareket edilmelidir.",
    },
    {
      "name": "Ocean",
      "price": 70.0,
      "type": "vitamin",
      "description":
          "Günlük vitamin ve mineral ihtiyacını desteklemeye yardımcı olan bu takviye; enerji metabolizmasının normal işleyişine, bağışıklık sisteminin desteklenmesine ve genel vücut dengesinin korunmasına katkı sağlayabilir. Önerilen kullanım miktarı için ürün ambalajındaki talimatlar veya uzman önerisi dikkate alınmalıdır.",
    },
    {
      "name": "Solgar B12",
      "price": 200.0,
      "type": "vitamin",
      "description":
          "Vitamin B12 desteği sağlayan bu takviye; enerji oluşum metabolizmasını, sinir sisteminin normal işleyişini ve yorgunluk hissinin azalmasını desteklemeye yardımcı olabilir. Önerilen kullanım miktarı için ürün etiketindeki talimatlar veya uzman tavsiyesi dikkate alınmalıdır.",
    },
    {
      "name": "Supradyn",
      "price": 300.0,
      "type": "vitamin",
      "description":
          "Günlük vitamin ve mineral desteği sunan bu takviye; enerji seviyelerinin korunmasına, bağışıklık sisteminin desteklenmesine ve yoğun tempoda vücudun ihtiyaç duyduğu besin öğelerinin tamamlanmasına yardımcı olabilir. Kullanım miktarı için ürün ambalajındaki öneriler veya uzman tavsiyesi dikkate alınmalıdır.",
    },
    {
      "name": "Kiperin",
      "price": 500.0,
      "type": "vitamin",
      "description":
          "Vitamin, mineral ve özel içeriklerle günlük beslenme düzenini desteklemeye yardımcı olan bu takviye ürünleri; enerji seviyelerinin korunmasına, bağışıklık sisteminin desteklenmesine ve genel vücut dengesinin sürdürülmesine katkı sağlayabilir. Kullanım miktarı için ürün ambalajındaki talimatlar veya uzman önerisi dikkate alınmalıdır.",
    },
    {
      "name": "Rennie",
      "price": 150.0,
      "type": "mide",
      "description":
          "Mide yanması, hazımsızlık ve reflüye bağlı mide asidi şikâyetlerinin hafifletilmesine yardımcı olan bu ilaç, fazla mide asidini nötralize ederek hızlı rahatlama sağlayabilir. Kullanım miktarı için prospektüs bilgileri veya uzman önerisi dikkate alınmalıdır.",
    },
    {
      "name": "Gaviscon",
      "price": 180.0,
      "type": "mide",
      "description":
          "Mide yanması, reflü ve hazımsızlık kaynaklı şikâyetlerin hafifletilmesine yardımcı olan bu ilaç, mide içeriğinin yemek borusuna kaçışını azaltarak rahatlama sağlayabilir. Kullanım miktarı için prospektüs bilgileri veya uzman önerisi dikkate alınmalıdır.",
    },
    {
      "name": "Lansor",
      "price": 220.0,
      "type": "mide",
      "description":
          "Mide asidini azaltmaya yardımcı olan bu ilaç; reflü, mide yanması ve mide ülseri gibi asit kaynaklı şikâyetlerin tedavisinde kullanılabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi doğrultusunda hareket edilmesi tavsiye edilir.",
    },
    {
      "name": "Omeprazol",
      "price": 240.0,
      "type": "mide",
      "description":
          "Mide asidi üretimini azaltmaya yardımcı olan bu ilaç; reflü, mide yanması ve mide ülseri gibi asit kaynaklı rahatsızlıkların tedavisinde kullanılabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi doğrultusunda hareket edilmesi tavsiye edilir.",
    },
    {
      "name": "Parafon",
      "price": 90.0,
      "type": "kas",
      "description":
          "Kas spazmları ve buna bağlı gelişen ağrıların hafifletilmesine yardımcı olan bu ilaç, kas gevşetici ve ağrı kesici etkisiyle rahatlama sağlayabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi dikkate alınmalıdır.",
    },
    {
      "name": "Cabral",
      "price": 240.0,
      "type": "kas",
      "description":
          "Kas spazmları, kas tutulmaları ve buna bağlı ağrıların hafifletilmesine yardımcı olan bu ilaç, kas gevşetici etkisiyle hareket konforunun artmasına destek olabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi doğrultusunda hareket edilmesi tavsiye edilir.",
    },
    {
      "name": "Lioresal",
      "price": 240.0,
      "type": "kas",
      "description":
          "Kas spazmları ve kaslarda oluşan sertlik hissinin azaltılmasına yardımcı olan bu ilaç, kas gevşetici etkisiyle hareket kabiliyetini destekleyebilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi dikkate alınmalıdır.",
    },
    {
      "name": "Tizanidin",
      "price": 240.0,
      "type": "kas",
      "description":
          "Kas spazmları, kas sertliği ve buna bağlı gelişen ağrıların hafifletilmesine yardımcı olan bu ilaç, kas gevşetici etkisiyle rahatlama sağlayabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi doğrultusunda hareket edilmesi tavsiye edilir.",
    },
    {
      "name": "Aferin",
      "price": 170.0,
      "type": "soguk",
      "description":
          "Soğuk algınlığı ve grip belirtilerinin hafifletilmesine yardımcı olan bu ilaç; ateş, baş ağrısı, burun akıntısı ve halsizlik gibi şikâyetlerde rahatlama sağlayabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi dikkate alınmalıdır.",
    },
    {
      "name": "Tylol Hot",
      "price": 40.0,
      "type": "soguk",
      "description":
          "Soğuk algınlığı ve grip belirtilerinin hafifletilmesine yardımcı olan bu ilaç; ateş, baş ağrısı, burun tıkanıklığı ve halsizlik gibi şikâyetlerde rahatlama sağlayabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi doğrultusunda hareket edilmesi tavsiye edilir.",
    },
    {
      "name": "Gripin",
      "price": 60.0,
      "type": "soguk",
      "description":
          "Soğuk algınlığı ve grip belirtilerinin hafifletilmesine yardımcı olan bu ilaç; ateş, baş ağrısı, burun tıkanıklığı ve halsizlik gibi şikâyetlerde rahatlama sağlayabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi doğrultusunda hareket edilmesi tavsiye edilir.",
    },
    {
      "name": "İbuCold",
      "price": 130.0,
      "type": "soguk",
      "description":
          "Soğuk algınlığı ve grip belirtilerinin hafifletilmesine yardımcı olan bu ilaç; ateş, baş ağrısı, halsizlik ve burun akıntısı gibi şikâyetlerde rahatlama sağlayabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi dikkate alınmalıdır.",
    },
    {
      "name": "Coldaway",
      "price": 120.0,
      "type": "soguk",
      "description":
          "Soğuk algınlığı ve grip belirtilerinin hafifletilmesine yardımcı olan bu ilaç; ateş, baş ağrısı, burun tıkanıklığı ve halsizlik gibi şikâyetlerde rahatlama sağlayabilir. Kullanım şekli ve dozu için prospektüs bilgileri veya uzman önerisi dikkate alınmalıdır.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Burada watch yerine read kullanıyoruz.
    // Bu ekran sepet sayısını göstermiyor, sadece butona basınca sepete ekliyor.
    final cart = context.read<Cart>();

    final ilaclar = tumIlaclar.where((i) {
      return i["type"] == widget.kategori &&
          i["name"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    final baslik = kategoriBasligi();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("$baslik İlaçları"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$baslik kategorisindeki ilaçlar",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // TextField arama kutusudur.
          // onChanged her harf yazıldığında çalışır ve listeyi filtreler.
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "İlaç ara...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),

          Expanded(
            // ListView.builder, uzun listelerde sadece görünen satırları üretir.
            // Bu yüzden performanslı bir liste oluşturma yöntemidir.
            child: ListView.builder(
              itemCount: ilaclar.length,
              itemBuilder: (context, index) {
                final ilac = ilaclar[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      // Navigator.push ile yeni bir sayfaya geçiyoruz.
                      // ilac bilgisini detay sayfasına gönderiyoruz.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IlacDetayPage(ilac: ilac),
                        ),
                      );
                    },
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.medication, color: Colors.white),
                    ),
                    title: Text(ilac["name"]),
                    subtitle: Text("${ilac["price"]} TL"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        cart.addItem(ilac["name"], ilac["price"]);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Sepete eklendi"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text("Sepete Ekle"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
