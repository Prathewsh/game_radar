import 'package:flutter/material.dart';
import 'package:gamesradar/models/game.dart';
import 'package:gamesradar/static/colors.dart';

class PlatformChip extends StatelessWidget {
  final PlatformModel platform;
  final bool isSelected;
  final VoidCallback onTap;

  const PlatformChip({
    super.key,
    required this.platform,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(platform.name),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: bgColor,
      selectedColor: fgColor.withOpacity(0.2),
      checkmarkColor: fgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: fgColor.withOpacity(0.3)),
      ),
      labelStyle: TextStyle(
        color: isSelected ? fgColor : fgColor.withOpacity(0.7),
      ),
    );
  }
}
