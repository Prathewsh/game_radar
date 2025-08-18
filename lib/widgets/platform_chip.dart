import 'package:flutter/material.dart';
import 'package:gamesradar/models/platform.dart';

class PlatformChip extends StatelessWidget {
  final Platform platform;
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
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
      ),
    );
  }
}
