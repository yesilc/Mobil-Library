// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sek/repo/kitaplar_dao_repository.dart';

import '../components/book_tile.dart';
import '../varlıklar/kitaplar.dart';
import 'raflar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<Kitaplar>>? futureBooks;
  final TextEditingController _controller = TextEditingController();

  void getBooks(String aramaKelimesi) {
    setState(() {
      futureBooks = KitaplarRepository().kitapAra(aramaKelimesi);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    getBooks(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arama"),
        leading: BackButton(onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Raflar()));
        }),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Kitap adını giriniz.",
                icon: Icon(Icons.search),
              ),
              // onChanged: (aramaKelimesi) {
              //   getBooks(aramaKelimesi);
              // },
            ),
          ),
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
    );
  }
}
