// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sek/components/book_tile.dart';
import 'package:sek/repo/kitaplar_dao_repository.dart';

import '../varlıklar/kitaplar.dart';
import 'raflar.dart';

final formKey = GlobalKey<FormState>();

class FilterByFieldsPage extends StatefulWidget {
  const FilterByFieldsPage({Key? key}) : super(key: key);

  @override
  State<FilterByFieldsPage> createState() => _FilterByFieldsPageState();
}

class _FilterByFieldsPageState extends State<FilterByFieldsPage> {
  Future<List<Kitaplar>>? futureBooks;

  bool _isTur = false;
  bool _isYayin = false;
  bool _isYazar = false;
  String? _selectedTurValue;
  var cevirmenAdi = TextEditingController();
  var tfYayinEvi = TextEditingController();
  List<String> turler = [
    "Edebiyat",
    "Çocuk",
    "Eğitim ve Sınav Kitapları",
    "Başvuru",
    "Araştırma - Tarih",
    "Din Tasavvuf",
    "Sanat - Tasarım",
    "Felsefe",
    "Hobi",
    "Çizgi Roman",
    "Bilim",
    "Mizah"
  ];

  void fetchBooks(String? kitapTuru, String yayinEvi, String cevirmenAdi) {
    setState(() {
      futureBooks = KitaplarRepository().getFilteredBooks(
          kitapTur: kitapTuru, yayinEv: yayinEvi, cevirmenAd: cevirmenAdi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filtre"),
        leading: BackButton(onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Raflar()));
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tür filter
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: _isTur,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTur = value ?? false;
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Tür',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),

                // Yayın Evi filter
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: _isYayin,
                        onChanged: (bool? value) {
                          setState(() {
                            _isYayin = value ?? false;
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Yayin Evi',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),

                // Yazar Adı filter
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: _isYazar,
                        onChanged: (bool? value) {
                          setState(() {
                            _isYazar = value ?? false;
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Çevirmen Adı',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Visibility(
                visible: _isYazar || _isTur || _isYayin,
                child: Form(
                  key: formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Visibility(
                        visible: _isYazar,
                        child: TextFormField(
                          controller: cevirmenAdi,
                          maxLength: 20,
                          decoration: InputDecoration(
                            labelText: 'Cevirmen Adi',
                            border: OutlineInputBorder(),
                          ),
                          validator: (name) =>
                              name == '' ? "alan boş bırakılamaz" : null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: _isYayin,
                        child: TextFormField(
                          controller: tfYayinEvi,
                          maxLength: 20,
                          decoration: InputDecoration(
                            labelText: 'Yayin Evi',
                            border: OutlineInputBorder(),
                          ),
                          validator: (name) =>
                              name == '' ? "alan boş bırakılamaz" : null,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: _isTur,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none),
                            validator: (name) =>
                                name == null ? "alan boş bırakılamaz" : null,
                            itemHeight: 80,
                            menuMaxHeight: 400,
                            isExpanded: true,
                            hint: const Text('Kitap Türü'),
                            value: _selectedTurValue,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedTurValue = value;
                              });
                            },
                            items: turler
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          fetchBooks(_selectedTurValue, tfYayinEvi.text,
                              cevirmenAdi.text);
                        },
                        child: const Text("Ara"),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
            //BOOKTILES
            FutureBuilder(
                future: futureBooks,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    final List<Kitaplar>? kitap_listesi = snapshot.data;
                    if (kitap_listesi == null || kitap_listesi.isEmpty) {
                      return Expanded(
                          child: Center(
                        child: Text(
                          "Kitap Yok",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                      ));
                    } else {
                      return Expanded(
                          child: ListView.builder(
                        itemCount: kitap_listesi.length,
                        itemBuilder: (context, index) {
                          final kitap = kitap_listesi[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey)),
                              child: BookTile(
                                  kitapDt: kitap,
                                  kitapAdi: kitap.kitap_adi,
                                  yazarAdi: kitap.yazar_adi,
                                  cevirmenAdi: kitap.cevirmen_adi,
                                  yayinEvi: kitap.publisher,
                                  kitapTuru: kitap.tur,
                                  pdf_name: kitap.pdf_name,
                                  rafName: kitap.shelf_name,
                                  alinmaTarihi: kitap.alinan_tarih,
                                  okunmaTarihi: kitap.okunan_tarih,
                                  baskiNo: kitap.baski_no,
                                  favorite: kitap.favorite,
                                  okundu: kitap.read,
                                  kitapId: kitap.kitap_id,
                                  yorum: kitap.yorum),
                            ),
                          );
                        },
                      ));
                    }
                  }
                }))
          ],
        ),
      ),
    );
  }
}
