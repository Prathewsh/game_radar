// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:gamesradar/models/game.dart';
import 'package:gamesradar/models/platform.dart';
import 'package:gamesradar/services/games_service.dart';
import 'package:gamesradar/widgets/game_card.dart';
import 'package:gamesradar/widgets/app_error_widget.dart';
import 'package:gamesradar/widgets/app_empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:gamesradar/screens/game_detail_screen.dart';

class PlatformGamesScreen extends StatefulWidget {
  final PlatformModel platform;
  const PlatformGamesScreen({super.key, required this.platform});

  @override
  State<PlatformGamesScreen> createState() => _PlatformGamesScreenState();
}

class _PlatformGamesScreenState extends State<PlatformGamesScreen> {
  List<Game> _games = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final gamesService = Provider.of<GamesService>(context, listen: false);
      final games = await gamesService.getNewReleases(
        platforms: widget.platform.id.toString(),
      );

      // Sort games by release date (ascending - oldest first)
      games.sort((a, b) {
        try {
          // Parse the dates if they're not null
          final DateTime? dateA = a.releaseDate != null
              ? DateFormat('yyyy-MM-dd').parse(a.releaseDate)
              : null;
          final DateTime? dateB = b.releaseDate != null
              ? DateFormat('yyyy-MM-dd').parse(b.releaseDate)
              : null;

          // Handle null cases
          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1; // Push null dates to the end
          if (dateB == null) return -1;

          return dateA.compareTo(dateB);
        } catch (e) {
          // If parsing fails, keep original order
          return 0;
        }
      });

      setState(() {
        _games = games;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.platform.name)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_hasError
                ? AppErrorWidget(
                    message:
                        'Failed to load games for ${widget.platform.name}.',
                    onRetry: _loadGames,
                  )
                : (_games.isEmpty
                      ? AppEmptyWidget(
                          title: 'No games for this platform',
                          subtitle:
                              'We couldn\'t find any listed games for ${widget.platform.name}.',
                        )
                      : ListView.builder(
                          itemCount: _games.length,
                          itemBuilder: (context, index) {
                            return GameCard(
                              game: _games[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GameDetailScreen(game: _games[index]),
                                  ),
                                );
                              },
                            );
                          },
                        ))),
    );
  }
}
