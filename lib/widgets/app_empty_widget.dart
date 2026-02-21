import 'package:flutter/material.dart';
import 'package:gamesradar/static/colors.dart';

class AppEmptyWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AppEmptyWidget({
    super.key,
    this.title = 'No Games Found',
    this.subtitle = 'We couldn\'t find any games matching your criteria.',
    this.icon = Icons.videogame_asset_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fgColor.withOpacity(0.3), size: 80),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: fgColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: fgColor.withOpacity(0.6), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
