import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:gamesradar/static/colors.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color.fromARGB(
            255,
            45,
            60,
            65,
          ), // Slightly lighter than bgColor
          highlightColor: const Color.fromARGB(255, 55, 75, 80),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: double.infinity, height: 150, color: bgColor),
                const SizedBox(height: 16),
                Container(width: double.infinity, height: 20, color: bgColor),
                const SizedBox(height: 8),
                Container(width: 150, height: 16, color: bgColor),
              ],
            ),
          ),
        );
      },
    );
  }
}
