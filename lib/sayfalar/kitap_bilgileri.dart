import 'package:flutter/material.dart';
import 'package:sek/varl%C4%B1klar/kitaplar.dart';

// ignore: must_be_immutable
class KitapBilgileri extends StatefulWidget {
  Kitaplar kitap;

  KitapBilgileri({required this.kitap});

  @override
  State<KitapBilgileri> createState() => _KitapBilgileriState();
}

class _KitapBilgileriState extends State<KitapBilgileri> {
  var tfKitapAd = TextEditingController();
  var tfYazarAd = TextEditingController();
  var tfCevirmenAd = TextEditingController();
  var tfTur = TextEditingController();
  var tfBaskiNo = TextEditingController();
  var tfAlinmaTarihi = TextEditingController();
  var tfOkunmaTarihi = TextEditingController();
  var tfYorum = TextEditingController();
  var tfShelfName = TextEditingController();
  var tfFavorite = TextEditingController();
  var tfRead = TextEditingController();

  @override
  void initState() {
    super.initState();
    var kitap = widget.kitap;
    tfKitapAd.text = kitap.kitap_adi;
    tfYazarAd.text = kitap.yazar_adi;
    tfCevirmenAd.text = kitap.cevirmen_adi;
    tfTur.text = kitap.tur;
    tfBaskiNo.text = kitap.baski_no;
    tfAlinmaTarihi.text = kitap.alinan_tarih;
    tfOkunmaTarihi.text = kitap.okunan_tarih;
    tfYorum.text = kitap.yorum;
  }

  Future<void> kitap(
      String kitap_adi,
      String yazar_adi,
      String cevirmen_adi,
      String tur,
      String baski_no,
      String alinma_tarihi,
      String okunma_tarihi,
      String yorum) async {
    print(
        "Kitap: $kitap_adi - $yazar_adi - $cevirmen_adi - $tur - $baski_no - $alinma_tarihi - $okunma_tarihi - $yorum");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kitap Bilgileri "),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfKitapAd,
                decoration: const InputDecoration(hintText: "Kitap Adı"),
              ),
              TextField(
                controller: tfYazarAd,
                decoration: const InputDecoration(hintText: "Yazar Adı"),
              ),
              TextField(
                controller: tfCevirmenAd,
                decoration: const InputDecoration(hintText: "Çevirmen Adı"),
              ),
              TextField(
                controller: tfTur,
                decoration: const InputDecoration(hintText: "Tür"),
              ),
              TextField(
                controller: tfBaskiNo,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Baskı No"),
              ),
              TextField(
                controller: tfAlinmaTarihi,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(hintText: "Alınma Tarihi"),
              ),
              TextField(
                controller: tfOkunmaTarihi,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(hintText: "Okunma Tarihi"),
              ),
              TextField(
                controller: tfYorum,
                decoration: const InputDecoration(hintText: "Yorum"),
              ),
              ElevatedButton(
                onPressed: () {
                  // ignore: avoid_single_cascade_in_expression_statements
                  // context
                  //   ..read<KitapBilgiCubit>().kguncelle(
                  //       widget.kitap.kitap_id,
                  //       tfKitapAd.text,
                  //       tfYazarAd.text,
                  //       tfCevirmenAd.text,
                  //       tfTur.text,
                  //       tfBaskiNo.text,
                  //       tfAlinmaTarihi.text,
                  //       tfOkunmaTarihi.text,
                  //       tfYorum.text,
                  //       tfShelfName.text,
                  //       tfFavorite.hashCode,
                  //       tfRead.hashCode);
                },
                child: const Text(
                  "GÜNCELLE",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
