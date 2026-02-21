import 'package:flutter/material.dart';
import 'package:gamesradar/screens/upcoming_screen.dart';
import 'package:gamesradar/screens/new_releases_screen.dart';
import 'package:gamesradar/static/colors.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: fgColor),
                cursorColor: fgColor,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: fgColor.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(_currentIndex == 0 ? 'Upcoming Games' : 'New Releases'),
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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          UpcomingScreen(searchQuery: _searchQuery),
          NewReleasesScreen(searchQuery: _searchQuery),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Clear search when switching tabs (optional, but usually better UX)
            if (_isSearching) {
              _isSearching = false;
              _searchQuery = '';
              _searchController.clear();
            }
          });
        },
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
}
