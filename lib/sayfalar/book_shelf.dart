// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sek/components/raf_tile.dart';
import 'package:sek/cubit/anasayfa_cubit.dart';
import 'package:sek/rafDatabase/raf_db.dart';
import 'package:sek/utils/add_raf_button.dart';

import '../rafDatabase/rafModel.dart';
import '../utils/add_raf_widget.dart';

class BookShelfPage extends StatefulWidget {
  const BookShelfPage({super.key});

  @override
  State<BookShelfPage> createState() => _BookShelfPageState();
}

class _BookShelfPageState extends State<BookShelfPage> {
  Future<List<Raf>>? futureRafs;
  int rafCount = 0;
  final rafDb = RafDatabase();

  @override
  void initState() {
    super.initState();
    futureRafs = rafDb.fetchAll();
  }

  void fetchRafs() {
    setState(() {
      futureRafs = rafDb.fetchAll();
    });
  }

  void addShelf() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateRafWidget(
            onSubmit: (title) async {
              await rafDb.create(rafName: title);
              if (!mounted) return;
              fetchRafs();
              Navigator.of(context).pop();
            },
            operationTur: 'Raf Ekle',
          );
        });
  }

  void updateShelf(int id, String oldShelfName) {
    String newShelfName;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateRafWidget(
            onSubmit: (title) async {
              newShelfName = title;
              await rafDb.update(id, title);
              if (!mounted) return;
              context
                  .read<AnasayfaCubit>()
                  .updateShelf(newShelfName, oldShelfName);
              fetchRafs();
              Navigator.of(context).pop();
            },
            operationTur: 'Raf Güncelle',
          );
        });
  }

  void removeShelf(int id, String shelfName) async {
    await rafDb.delete(id);
    context.read<AnasayfaCubit>().deleteShelf(shelfName);
    fetchRafs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        FutureBuilder<List<Raf>>(
          future: futureRafs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Expanded(
                  child: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Check if snapshot data is not null before accessing it
              final List<Raf>? rafs = snapshot.data;
              if (rafs == null || rafs.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      "Hiç raf yok",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: rafs.length,
                    itemBuilder: (context, index) {
                      final raf = rafs[index];
                      return RafTile(
                        rafName: raf.rafName,
                        deleteFunction: (context) =>
                            removeShelf(raf.id, raf.rafName),
                        updateFunction: (context) =>
                            updateShelf(raf.id, raf.rafName),
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
        Container(
          height: 50,
          width: 200,
          child: AddRafButton(
            onPressed: addShelf,
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    ));
  }
}
