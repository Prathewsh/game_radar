import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamesradar/models/game.dart';
import 'package:gamesradar/services/games_service.dart';
import 'package:gamesradar/widgets/game_card.dart';
import 'package:gamesradar/widgets/loading_shimmer.dart';
import 'package:gamesradar/screens/game_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Game> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  bool _hasError = false;

  Future<void> _searchGames(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _hasError = false;
      _searchResults.clear();
    });

    try {
      final gamesService = Provider.of<GamesService>(context, listen: false);
      final results = await gamesService.searchGames(query);
      setState(() {
        _searchResults.addAll(results);
        _hasSearched = true;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _hasError = true;
      });
    }
  }

  void _navigateToGameDetail(Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameDetailScreen(game: game)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search games...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _searchGames(_searchController.text),
            ),
          ),
          onSubmitted: _searchGames,
        ),
      ),
      body: _isSearching
          ? const LoadingShimmer()
          : _hasError
          ? const Center(child: Text('Failed to search games'))
          : _hasSearched && _searchResults.isEmpty
          ? const Center(child: Text('No games found'))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) => GameCard(
                game: _searchResults[index],
                onTap: () => _navigateToGameDetail(_searchResults[index]),
              ),
            ),
    );
  }
}
