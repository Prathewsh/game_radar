import 'package:flutter/material.dart';
import 'package:gamesradar/static/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  // Handle search query change if needed
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
