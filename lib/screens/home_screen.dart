import 'package:flutter/material.dart';
import 'package:gamesradar/static/colors.dart';
import 'package:gamesradar/models/game.dart';
import 'package:gamesradar/services/games_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<PlatformModel> _platforms = [];
  bool _isLoadingPlatforms = true;
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlatforms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPlatforms() async {
    try {
      final gamesService = Provider.of<GamesService>(context, listen: false);
      final platforms = await gamesService.getPlatforms();
      setState(() {
        _platforms = platforms;
        _isLoadingPlatforms = false;
      });
    } catch (e) {
      setState(() => _isLoadingPlatforms = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: fgColor),
                cursorColor: fgColor,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: fgColor.withValues(alpha: 0.5)),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text('Game Radar'),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: fgColor),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: fgColor,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
