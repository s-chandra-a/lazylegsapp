import 'package:flutter/material.dart';
import 'package:lazy_legs/pages/bottom_navigation.dart';
import 'package:lazy_legs/pages/orders.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.grey),
          bodyMedium: TextStyle(color: Colors.grey),
          bodySmall: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black, fontSize: 24),
        ),

        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: BottomNavigation(),
    );
  }
}

