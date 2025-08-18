import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gamesradar/models/game.dart';
import 'package:gamesradar/widgets/platform_chip.dart';

class GameDetailScreen extends StatelessWidget {
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  Future<void> _launchWebsite(String? url) async {
    if (url == null) return;
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(game.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (game.backgroundImage != null)
              CachedNetworkImage(
                imageUrl: game.backgroundImage!,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[200], height: 200),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  height: 200,
                  child: const Icon(Icons.error),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(game.releaseDate),
                      const Spacer(),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(game.ratingString),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (game.platforms.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Platforms',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: game.platforms
                              .map(
                                (platform) => PlatformChip(
                                  platform: platform,
                                  isSelected: false,
                                  onTap: () {},
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  if (game.description != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(game.description!),
                        const SizedBox(height: 16),
                      ],
                    ),
                  if (game.website != null)
                    OutlinedButton(
                      onPressed: () => _launchWebsite(game.website),
                      child: const Text('Official Website'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
