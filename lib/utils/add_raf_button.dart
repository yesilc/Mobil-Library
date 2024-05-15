import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddRafButton extends StatelessWidget {
  void Function()? onPressed;
  AddRafButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        "Yeni Raf Ekle",
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}
