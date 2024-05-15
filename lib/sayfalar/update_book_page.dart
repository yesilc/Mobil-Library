import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sek/cubit/kitap_bilgi_cubit.dart';
import 'package:sek/rafDatabase/raf_db.dart';
import 'package:sek/varl%C4%B1klar/kitaplar.dart';

import '../rafDatabase/rafModel.dart';

// ignore: must_be_immutable
class UpdateBookPage extends StatefulWidget {
  Kitaplar kitapDt;

  UpdateBookPage({Key? key, required this.kitapDt}) : super(key: key);

  @override
  State<UpdateBookPage> createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  late bool _isFavorite;
  late bool _isRead;
  String? _selectedTurValue;
  String? _selectedRafValue;
  final rafDb = RafDatabase();
  var tfKitapAd = TextEditingController();
  var tfYazarAd = TextEditingController();
  var tfCevirmenAd = TextEditingController();
  var tfYayinEv = TextEditingController();
  var tfBaskiNo = TextEditingController();
  var tfYorum = TextEditingController();
  TextEditingController _alinmaDateController = TextEditingController();
  TextEditingController _okunmaDateController = TextEditingController();
  Future<List<Raf>>? futureRafs;
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

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.kitapDt.favorite == 1;
    _isRead = widget.kitapDt.read == 1;
    tfKitapAd.text = widget.kitapDt.kitap_adi;
    tfYazarAd.text = widget.kitapDt.yazar_adi;
    tfCevirmenAd.text = widget.kitapDt.cevirmen_adi;
    tfYayinEv.text = widget.kitapDt.publisher;
    tfBaskiNo.text = widget.kitapDt.baski_no;
    tfYorum.text = widget.kitapDt.yorum;
    _alinmaDateController.text = widget.kitapDt.alinan_tarih;
    _okunmaDateController.text = widget.kitapDt.okunan_tarih;
    _selectedTurValue = widget.kitapDt.tur;
    _selectedRafValue = widget.kitapDt.shelf_name;
    futureRafs = rafDb.fetchAll();
  }

  Future<void> _selectDateAlinma(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _alinmaDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectDateOkunma(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _okunmaDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Kitap Güncelle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: tfKitapAd,
              maxLength: 25,
              decoration: InputDecoration(
                labelText: 'Kitap Adı',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: tfYazarAd,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Yazar Adı',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              maxLength: 20,
              controller: tfCevirmenAd,
              decoration: InputDecoration(
                labelText: 'Çevirmen Adı',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: tfYayinEv,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Yayin Evi',
                border: OutlineInputBorder(),
              ),
              validator: (name) => name == '' ? "alan boş bırakılamaz" : null,
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: tfBaskiNo,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Baski No',
                border: OutlineInputBorder(),
              ),
              validator: (name) => name == '' ? "alan boş bırakılamaz" : null,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Yorum/İnceleme:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            TextField(
              controller: tfYorum,
              maxLength: 1000,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Alinma Tarihi:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            TextField(
              controller: _alinmaDateController,
              readOnly: true,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDateAlinma(context);
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey.shade300))),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Okunma Tarihi:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            TextField(
              controller: _okunmaDateController,
              readOnly: true,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDateOkunma(context);
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey.shade300))),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
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
                items: turler.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
              ),
            ),
            FutureBuilder<List<Raf>>(
              future: futureRafs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Raf> rafs = snapshot.data!;
                  return Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      itemHeight: 80,
                      isExpanded: true,
                      value: _selectedRafValue,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedRafValue = value;
                        });
                      },
                      hint: Text("Kitap Rafı"),
                      items: rafs.map((raf) {
                        return DropdownMenuItem<String>(
                          value: raf.rafName,
                          child: Text(raf.rafName),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: _isFavorite,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFavorite = value ?? false;
                      });
                    },
                  ),
                ),
                const Text(
                  'Favori',
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(width: 20),
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: _isRead,
                    onChanged: (bool? value) {
                      setState(() {
                        _isRead = value ?? false;
                      });
                    },
                  ),
                ),
                const Text(
                  'Okundu',
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<KitapBilgiCubit>().kguncelle(
                      widget.kitapDt.kitap_id,
                      tfKitapAd.text,
                      tfYazarAd.text,
                      tfCevirmenAd.text,
                      tfYayinEv.text,
                      _selectedTurValue!,
                      tfBaskiNo.text,
                      _alinmaDateController.text,
                      _okunmaDateController.text,
                      tfYorum.text,
                      _selectedRafValue!,
                      _isFavorite ? 1 : 0,
                      _isRead ? 1 : 0);
                  Fluttertoast.showToast(
                      msg: "Güncellendi",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: const Text("Kitap Güncelle")),
          ],
        ),
      ),
    );
  }
}
