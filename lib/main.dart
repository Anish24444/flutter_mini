import 'package:flutter/material.dart';
import 'package:untitled/pages/bit_project.dart';
import 'package:untitled/pages/login_page.dart';

import 'package:untitled/utils/routes.dart';

void main() {
  runApp(const  MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,



      themeMode: ThemeMode.dark,
        darkTheme: ThemeData(


        brightness: Brightness.light,
      ),
routes:{
        "/" : (context) =>  const LoginPage(),
  MyRoutes.loginRoute:(context)=> const  ProductRankingScreen(),
        MyRoutes.homeRoute: (context) => const ProductRankingScreen(),


    }
    );

  }
  }

