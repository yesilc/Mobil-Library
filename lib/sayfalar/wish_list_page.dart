// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:sek/wishListDatabase/wl_db.dart";

import "../wishListDatabase/wlModel.dart";
import "raflar.dart";

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  Future<List<WList>>? wishList;
  final wListDb = WListDatabase();
  late final TextEditingController _controller;
  var istekKitap = TextEditingController();
  var istekYazar = TextEditingController();
  var istekYayinEvi = TextEditingController();

  @override
  void initState() {
    super.initState();
    wishList = wListDb.fetchAll();
    _controller = TextEditingController();
  }

  void fetchWList() {
    setState(() {
      wishList = wListDb.fetchAll();
    });
  }

  void refreshPage() {
    setState(() {});
  }

  void addAndRecordAddress(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Adres ekle"),
            content: Form(
              child: TextField(
                controller: _controller,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(("İptal")),
              ),
              TextButton(
                onPressed: () {
                  wListDb.updateAddress(id, _controller.text);
                  Navigator.pop(context);
                  _controller.clear();
                  setState(() {
                    wishList = wListDb.fetchAll();
                  });
                },
                child: const Text("Ekle"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("İstek Listesi"),
          leading: BackButton(onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Raflar()));
          }),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Yeni İstek"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Kitap Adı:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: istekKitap,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      Text(
                        "Yazar Adı: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: istekYazar,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                      Text(
                        "Yayın Evi: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: istekYayinEvi,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () {
                        wListDb.create(
                            bookName: istekKitap.text,
                            author: istekYazar.text,
                            publisher: istekYayinEvi.text);
                        istekKitap.clear();
                        istekYayinEvi.clear();
                        istekYazar.clear();
                        Navigator.pop(context, 'OK');
                        fetchWList();
                      },
                      child: const Text('Tamam'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        body: Column(
          children: [
            FutureBuilder<List<WList>>(
                future: wishList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final List<WList>? wishes = snapshot.data;
                    if (wishes == null || wishes.isEmpty) {
                      return Expanded(
                          child: Center(
                        child: Text(
                          "Hiç istek yok",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                      ));
                    } else {
                      return Expanded(
                          child: ListView.builder(
                        itemCount: wishes.length,
                        itemBuilder: (context, index) {
                          final wish = wishes[index];
                          return GestureDetector(
                            onLongPress: () {
                              addAndRecordAddress(wish.id);
                              refreshPage();
                            },
                            child: Card(
                              child: ExpansionTile(
                                title: Text(wish.bookName),
                                subtitle: Text("Yazar: " +
                                    wish.author +
                                    "\n" +
                                    "Yayın Evi: " +
                                    wish.publisher),
                                trailing: IconButton(
                                    icon: Icon(Icons.delete_sharp),
                                    onPressed: () {
                                      wListDb.delete(wish.id);
                                      fetchWList();
                                    }),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(wish.address == ''
                                        ? "Ek bilgi yok"
                                        : wish.address),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ));
                    }
                  }
                })
          ],
        ));
  }
}
