// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamesradar/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:gamesradar/static/colors.dart';
import 'package:gamesradar/services/games_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [Provider<GamesService>(create: (_) => GamesService())],
      child: const GamesRadarApp(),
    ),
  );
}

class GamesRadarApp extends StatelessWidget {
  const GamesRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Radar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: fgColor,
          brightness: Brightness.dark,
          background: bgColor,
          surface: bgColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: fgColor,
          ),
        ),
        iconTheme: const IconThemeData(color: fgColor),
        cardTheme: CardThemeData(
          color: const Color.fromARGB(
            255,
            45,
            60,
            65,
          ), // Slightly lighter than bgColor
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          surfaceTintColor: Colors.transparent,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: fgColor),
          bodyMedium: TextStyle(color: fgColor),
          titleLarge: TextStyle(color: fgColor),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: bgColor,
          selectedItemColor: fgColor,
          unselectedItemColor: Colors.grey,
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: bgColor),
      ),
      home: const SplashScreen(),
    );
  }
}
