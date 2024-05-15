import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sek/cubit/anasayfa_cubit.dart';
import 'package:sek/sayfalar/add_book_page.dart';
import 'package:sek/sayfalar/kitap_bilgileri.dart';
import 'package:sek/varl%C4%B1klar/kitaplar.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYap = false;

  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().kitaplariGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYap
            ? TextField(
                decoration:
                    const InputDecoration(hintText: "Kitap adını giriniz."),
                onChanged: (aramaSonucu) {
                  context.read<AnasayfaCubit>().ara(aramaSonucu);
                },
              )
            : const Text("Ev Kütüphanesi "),
        backgroundColor: Colors.red,
        actions: [
          aramaYap
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      aramaYap = false;
                    });
                    context.read<AnasayfaCubit>().kitaplariGetir();
                  },
                  icon: const Icon(Icons.cancel),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      aramaYap = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                )
        ],
      ),
      body: BlocBuilder<AnasayfaCubit, List<Kitaplar>>(
        builder: (context, kitapListesi) {
          if (kitapListesi.isNotEmpty) {
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: kitapListesi.length,
              itemBuilder: (context, index) {
                var kitap = kitapListesi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KitapBilgileri(kitap: kitap),
                      ),
                    ).then((value) {
                      context.read<AnasayfaCubit>().kitaplariGetir();
                    });
                  },
                  child: Card(
                    elevation: 15.0,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  child: Text(
                                    "Kitap Adı: ${kitap.kitap_adi}",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  child: Text(
                                    "Yazar Adı: ${kitap.yazar_adi}",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  child: Text(
                                    "Çevirmen Adı: ${kitap.cevirmen_adi}",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  child: Text(
                                    "Baskı No: ${kitap.baski_no}",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("${kitap.kitap_adi} silinsin mi?"),
                                  action: SnackBarAction(
                                    label: "EVET",
                                    onPressed: () {
                                      context
                                          .read<AnasayfaCubit>()
                                          .sil(kitap.kitap_id);
                                    },
                                  ),
                                ),
                              );
                            },
                            icon:
                                const Icon(Icons.delete, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Kitap bulunamadı."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookPage()),
          ).then((value) {
            context.read<AnasayfaCubit>().kitaplariGetir();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
