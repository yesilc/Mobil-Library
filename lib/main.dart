import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sek/cubit/anasayfa_cubit.dart';
import 'package:sek/cubit/kitap_bilgi_cubit.dart';
import 'package:sek/cubit/kitap_ekle_cubit.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:sek/sayfalar/anasayfa.dart';
import 'package:sek/sayfalar/raflar.dart';

void main() {
  //Initialize FFI
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => KitapEkleCubit()),
        BlocProvider(create: (context) => KitapBilgiCubit()),
        BlocProvider(create: (context) => AnasayfaCubit()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Raflar()), //AddBookPage()),
    );
  }
}
