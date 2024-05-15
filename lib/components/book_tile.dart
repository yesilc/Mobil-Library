// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:info_popup/info_popup.dart';
import 'package:sek/cubit/anasayfa_cubit.dart';
import 'package:sek/repo/kitaplar_dao_repository.dart';
import 'package:sek/sayfalar/pdfviewer_page.dart';
import 'package:sek/sayfalar/update_book_page.dart';
import 'package:sek/utils/add_or_remove_favorite.dart';
import 'package:sek/varl%C4%B1klar/kitaplar.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

// ignore: must_be_immutable
class BookTile extends StatefulWidget {
  Kitaplar kitapDt;
  String kitapAdi;
  String yazarAdi;
  String cevirmenAdi;
  String yayinEvi;
  String kitapTuru;
  String alinmaTarihi;
  String okunmaTarihi;
  String rafName;
  String yorum;
  String baskiNo;
  String pdf_name;
  int favorite;
  int okundu;
  int kitapId;

  BookTile(
      {super.key,
      required this.kitapDt,
      required this.kitapAdi,
      required this.yazarAdi,
      required this.cevirmenAdi,
      required this.yayinEvi,
      required this.kitapTuru,
      required this.rafName,
      required this.alinmaTarihi,
      required this.okunmaTarihi,
      required this.pdf_name,
      required this.baskiNo,
      required this.favorite,
      required this.okundu,
      required this.kitapId,
      required this.yorum});

  @override
  State<BookTile> createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  bool isFavorite = false;
  bool isVisible = false;
  KitaplarRepository bookRepo = KitaplarRepository();
  Future<List<String>>? futurePdf;
  //String? _selectedPdf;
  String _fileText = "";
  Icon favoriteIcon = Icon(Icons.favorite_border);
  void updateFunction(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateBookPage(kitapDt: widget.kitapDt)));
  }

  void deleteFunction(BuildContext context) {
    context.read<AnasayfaCubit>().sil(widget.kitapId);
    Fluttertoast.showToast(
        msg: "Kitap silindi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    super.initState();
    isFavorite = (widget.favorite == 0) ? false : true;
    //futurePdf = getPdfFileNames();
  }

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    await context
        .read<AnasayfaCubit>()
        .setFavoriteStatus(widget.kitapId, isFavorite ? 1 : 0);
  }

  //PDF HANDLING

  void pdfHandling(String pdfName) {
    if (pdfName == '') {
      _pickFile();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("OKU/GÜNCELLE"),
            actions: <Widget>[
              TextButton(
                child: Text("Oku"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PDFViewerPage(
                              pdfName: widget.pdf_name,
                            )),
                  );
                },
              ),
              TextButton(
                child: Text("Güncelle"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickFile();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      // normal file
      File _file = File(result.files.single.path!);
      setState(() {
        _fileText = _file.path;
        bookRepo.updatePdf(_fileText, widget.kitapId);
        Navigator.of(context).pop();
      });
    } else {
      /// User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(12),
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Color.fromARGB(255, 207, 207, 207),
            ),
            SlidableAction(
                borderRadius: BorderRadius.circular(12),
                onPressed: updateFunction,
                icon: Icons.change_circle_outlined,
                backgroundColor: Colors.white
                //borderRadius: BorderRadius.circular(12),
                ),
          ],
        ),
        child: GestureDetector(
          onLongPress: () {
            pdfHandling(widget.pdf_name);
          },
          child: Column(
            children: [
              SizedBox(
                height: 210,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          widget.kitapAdi,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Yazar: " + widget.yazarAdi,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "Çeviri: " + widget.cevirmenAdi,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "Tür: " + widget.kitapTuru,
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Yayin Evi: " + widget.yayinEvi,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "Baskı: " + widget.baskiNo,
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: [
                                InfoPopupWidget(
                                  arrowTheme: InfoPopupArrowTheme(
                                    color: Colors.pink,
                                  ),
                                  contentTitle: widget.yorum == ''
                                      ? "Yorum yapılmamış"
                                      : widget.yorum,
                                  child: const Text('    YORUM'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.yellow),
                                        onPressed: () {
                                          setState(() {
                                            isVisible = !isVisible;
                                          });
                                        },
                                        child: const Text(
                                          'DETAY',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            FavoriteButton(
                                isFavorite: isFavorite, onTap: toggleFavorite)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Visibility(
                    visible: isVisible,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(color: Colors.black, width: 2))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Raf: " + widget.rafName),
                                Text("Sayfa Sayısı: 110")
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Alinma Tarihi: " + widget.alinmaTarihi,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Okunma Tarihi: " + widget.okunmaTarihi,
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
