// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamesradar/screens/splash_screen.dart';
import 'package:provider/provider.dart';
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
        // Use Material 3
        useMaterial3: true,
        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
          background: Colors.grey[100]!,
        ),
        // App bar theme
        appBarTheme: const AppBarTheme(
          elevation: 1,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        // Card theme - 修改为 CardThemeData
        cardTheme: const CardThemeData(
          clipBehavior: Clip.antiAlias,
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          surfaceTintColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        // Card theme - 修改为 CardThemeData
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          surfaceTintColor: Colors.transparent,
        ),
      ),

      // home: const HomeScreen(),
      home: const SplashScreen(),
    );
  }
}
