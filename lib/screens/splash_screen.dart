import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gamesradar/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to home after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Match background color to theme
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 150,
            height: 150,
            // This ensures the background of the image matches the screen
            color: Theme.of(context).colorScheme.surface,
            colorBlendMode: BlendMode.dstIn,
          ),
        ),
      ),
    );
  }
}
