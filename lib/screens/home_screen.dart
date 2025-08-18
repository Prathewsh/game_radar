import 'package:flutter/material.dart';
import 'package:gamesradar/screens/games_list_screen.dart';
import 'package:gamesradar/screens/search_screen.dart';
import 'package:gamesradar/screens/platform_games_screen.dart'; // Add this import
import 'package:gamesradar/models/platform.dart';
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
  List<Platform> _platforms = [];
  bool _isLoadingPlatforms = true;

  @override
  void initState() {
    super.initState();
    _loadPlatforms();
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
        title: const Text('Game Radar'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          GamesListScreen(title: 'Upcoming Games', showUpcoming: true),
          GamesListScreen(title: 'New Releases', showUpcoming: false),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.upcoming),
            label: 'Upcoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'New Releases',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepOrange),
            child: Text(
              'GamesRadar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'RELEASES',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          _isLoadingPlatforms
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: _platforms
                      .take(10)
                      .map(
                        (platform) => ListTile(
                          leading: const Icon(Icons.videogame_asset),
                          title: Text(platform.name),
                          onTap: () {
                            Navigator.pop(context); // Close drawer
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlatformGamesScreen(platform: platform),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const SettingsScreen()),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
