import 'package:flutter/material.dart';
import 'package:gamesradar/screens/game_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:gamesradar/models/game.dart';
import 'package:gamesradar/services/games_service.dart';
import 'package:gamesradar/widgets/game_card.dart';
import 'package:gamesradar/widgets/loading_shimmer.dart';
import 'package:gamesradar/widgets/app_error_widget.dart';
import 'package:gamesradar/widgets/app_empty_widget.dart';

class GamesListScreen extends StatefulWidget {
  final bool showUpcoming;
  final String searchQuery;
  const GamesListScreen({
    super.key,
    required this.showUpcoming,
    this.searchQuery = '',
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
      appBar: AppBar(
        title: Text(widget.showUpcoming ? 'Upcoming Games' : 'New Releases'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final filteredGames = widget.searchQuery.isEmpty
        ? _games
        : _games
              .where(
                (game) => game.name.toLowerCase().contains(
                  widget.searchQuery.toLowerCase(),
                ),
              )
              .toList();

    if (_hasError && filteredGames.isEmpty) {
      return AppErrorWidget(onRetry: () => _loadGames(isRefresh: true));
    }

    if (filteredGames.isEmpty && _isLoading) {
      return const LoadingShimmer();
    }

    if (filteredGames.isEmpty && !_isLoading && !_hasError) {
      return AppEmptyWidget(
        subtitle: widget.searchQuery.isNotEmpty
            ? 'No results for your search.'
            : 'No games available at the moment.',
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount:
          filteredGames.length +
          (_hasMore && widget.searchQuery.isEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < filteredGames.length) {
          final current = filteredGames[index];
          return GameCard(
            game: current,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailScreen(game: current),
                ),
              );
            },
          );
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
