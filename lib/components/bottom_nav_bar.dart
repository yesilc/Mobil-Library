// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class BotNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  BotNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GNav(
          color: Colors.grey.shade400,
          activeColor: Colors.grey.shade700,
          tabActiveBorder: Border.all(color: Colors.white),
          tabBackgroundColor: Colors.grey.shade100,
          mainAxisAlignment: MainAxisAlignment.center,
          tabBorderRadius: 16,
          onTabChange: (value) => onTabChange!(value),
          tabs: [
            GButton(
              icon: Icons.shelves,
              text: "Raflar",
            ),
            GButton(
              icon: Icons.favorite,
              text: "Favoriler",
            ),
            GButton(
              icon: Icons.bookmark_outlined,
              text: "İstek Listesi",
            )
          ]),
    );
  }
}
