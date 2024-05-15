// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sek/components/bottom_nav_bar.dart';
import 'package:sek/sayfalar/add_book_page.dart';
import 'package:sek/sayfalar/filter_by_fields_page.dart';
import 'package:sek/sayfalar/searching_page.dart';
import 'package:sek/sayfalar/single_shelf_page.dart';
import 'package:sek/sayfalar/wish_list_page.dart';

import 'book_shelf.dart';
import 'favorit_books.dart';

class Raflar extends StatefulWidget {
  const Raflar({super.key});

  @override
  State<Raflar> createState() => _RaflarState();
}

class _RaflarState extends State<Raflar> {
  //this selected index is to control the bottom nav bar
  int _selectedIndex = 0;
  //this method will update our selected index
  //when the user taps on the bottom bar
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //pages to display
  final List<Widget> _pages = [
    //BookShelf page
    const BookShelfPage(),

    //favorit books page
    const FavoritPage(),

    //finished books page
    const WishListPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BotNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        title: Text(
          "Kütüphane",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: <Widget>[
          (IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBookPage()),
              );
            },
            icon: Icon(Icons.add_box),
            color: Colors.white,
          )),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            onPressed: () => {
              Scaffold.of(context).openDrawer(),
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade900,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                //logo
                DrawerHeader(
                    child: Text(
                  "Sanal Kütüphane",
                  style: TextStyle(fontSize: 30),
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(color: Colors.grey.shade800),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FilterByFieldsPage()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.filter_alt_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Filtreleme',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Ara',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleShelfPage(
                                  rafName: '-',
                                )),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.archive_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Koli',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 25),
              child: GestureDetector(
                onTap: () => exit(0),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Çıkış',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
