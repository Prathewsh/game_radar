import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamesradar/models/game.dart';
import 'package:gamesradar/services/games_service.dart';
import 'package:gamesradar/widgets/game_card.dart';
import 'package:gamesradar/widgets/loading_shimmer.dart';

class GamesListScreen extends StatefulWidget {
  final String title;
  final bool showUpcoming;
  const GamesListScreen({
    super.key,
    required this.title,
    required this.showUpcoming,
  });

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  final List<Game> _games = [];
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _hasError = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadGames();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        _loadGames();
      }
    }
  }

  Future<void> _loadGames({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _page = 1;
        _hasMore = true;
        _hasError = false;
      }
    });

    try {
      final gamesService = Provider.of<GamesService>(context, listen: false);
      final newGames = widget.showUpcoming
          ? await gamesService.getUpcomingGames(page: _page)
          : await gamesService.getNewReleases(page: _page);

      setState(() {
        if (isRefresh) {
          _games.clear();
        }
        _games.addAll(newGames);
        _hasMore = newGames.length >= 20; // Assuming page_size is 20
        _page++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load games: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_hasError && _games.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load games'),
            ElevatedButton(
              onPressed: () => _loadGames(isRefresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _games.isEmpty && _isLoading
        ? const LoadingShimmer()
        : ListView.builder(
            controller: _scrollController,
            itemCount: _games.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _games.length) {
                return GameCard(game: _games[index]);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
