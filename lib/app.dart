import 'package:flutter/material.dart';
import 'package:shrine/cart.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/profile.dart';
import 'package:shrine/supplemental/detail.dart';
import 'package:shrine/favorite.dart';
import 'package:shrine/mypage.dart';
import 'package:shrine/search.dart';
import 'package:shrine/signUp.dart';

import 'add.dart';
import 'home.dart';
import 'login.dart';

class ShrineApp extends StatelessWidget {
  ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.redAccent),
          ),
        ),
      ),
      title: 'Shrine',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const LoginPage(),
        '/signUp': (BuildContext context) => const SignUpPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/profile': (BuildContext context) => ProfilePage(),
        '/detail': (BuildContext context) => const DetailPage(),
        '/cart': (BuildContext context) => CartPage(),
        '/search': (BuildContext context) => const SearchPage(),
        // '/favorite': (BuildContext context) => const FavoritePage(),
        '/myPage': (BuildContext context) => const MyPage(),
        '/add': (BuildContext context) => AddPage(),
      },
    );
  }
}
