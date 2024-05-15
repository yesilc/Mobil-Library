import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sek/components/book_tile.dart';
import 'package:sek/cubit/anasayfa_cubit.dart';
import 'package:sek/sayfalar/raflar.dart';

import '../varlıklar/kitaplar.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  Future<List<Kitaplar>>? futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = context.read<AnasayfaCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favori Kitaplar"),
          leading: BackButton(onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Raflar()));
          }),
        ),
        backgroundColor: Colors.grey.shade200,
        body: FutureBuilder<List<Kitaplar>>(
            future: futureBooks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final List<Kitaplar>? kitaplar = snapshot.data;
                if (kitaplar == null || kitaplar.isEmpty) {
                  return const Center(
                    child: Text("Kitap Bulunamadı"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: kitaplar.length,
                    itemBuilder: (context, index) {
                      final kitap = kitaplar[index];
                      return BookTile(
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
                        yorum: kitap.yorum,
                      );
                    },
                  );
                }
              }
            }));
  }
}
