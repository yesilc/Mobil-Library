import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sek/components/book_tile.dart';
import 'package:sek/cubit/anasayfa_cubit.dart';
import '../varlıklar/kitaplar.dart';

// ignore: must_be_immutable
class SingleShelfPage extends StatefulWidget {
  String rafName = "";
  SingleShelfPage({Key? key, required this.rafName}) : super(key: key);

  @override
  State<SingleShelfPage> createState() => _SingleShelfPageState();
}

class _SingleShelfPageState extends State<SingleShelfPage> {
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().getRafBooks(widget.rafName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.rafName == '-' ? "Koli" : widget.rafName),
        ),
        backgroundColor: Colors.grey.shade200,
        body: BlocBuilder<AnasayfaCubit, List<Kitaplar>>(
          builder: (context, kitapListesi) {
            if (kitapListesi.isNotEmpty) {
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: kitapListesi.length,
                itemBuilder: (context, index) {
                  var kitap = kitapListesi[index];
                  return BookTile(
                    kitapDt: kitap,
                    kitapId: kitap.kitap_id,
                    kitapAdi: kitap.kitap_adi,
                    yazarAdi: kitap.yazar_adi,
                    cevirmenAdi: kitap.cevirmen_adi,
                    yayinEvi: kitap.publisher,
                    kitapTuru: kitap.tur,
                    yorum: kitap.yorum,
                    rafName: kitap.shelf_name,
                    alinmaTarihi: kitap.alinan_tarih,
                    okunmaTarihi: kitap.okunan_tarih,
                    pdf_name: kitap.pdf_name,
                    baskiNo: kitap.baski_no,
                    favorite: kitap.favorite,
                    okundu: kitap.read,
                  );
                },
              );
            } else {
              return const Center(child: Text("Kitap Bulunamadı."));
            }
          },
        ));
  }
}
