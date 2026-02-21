import 'package:flutter/material.dart';
import 'package:gamesradar/static/colors.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:gamesradar/models/game.dart';
import 'package:gamesradar/services/games_service.dart';
import 'package:gamesradar/widgets/game_card.dart';
import 'package:gamesradar/widgets/platform_chip.dart';
import 'package:gamesradar/widgets/loading_shimmer.dart';
import 'package:gamesradar/screens/game_detail_screen.dart';
import 'package:gamesradar/widgets/app_error_widget.dart';
import 'package:gamesradar/widgets/app_empty_widget.dart';

class UpcomingScreen extends StatefulWidget {
  final String searchQuery;
  const UpcomingScreen({super.key, this.searchQuery = ''});

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  final RefreshController _refreshController = RefreshController();
  final List<Game> _games = [];
  final List<PlatformModel> _platforms = [];
  String? _selectedPlatform;
  int _page = 1;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadPlatforms();
    await _loadGames();
  }

  Future<void> _loadPlatforms() async {
    try {
      final gamesService = Provider.of<GamesService>(context, listen: false);
      final platforms = await gamesService.getPlatforms();
      setState(() {
        _platforms.addAll(platforms);
      });
    } catch (e) {
      setState(() => _hasError = true);
    }
  }

  Future<void> _loadGames() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final gamesService = Provider.of<GamesService>(context, listen: false);
      final newGames = await gamesService.getUpcomingGames(
        page: _page,
        platforms: _selectedPlatform ?? '',
      );

      setState(() {
        _games.addAll(newGames);
        _page++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _page = 1;
      _games.clear();
    });
    await _loadGames();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await _loadGames();
    _refreshController.loadComplete();
  }

  void _onPlatformSelected(String? platformId) {
    setState(() {
      _selectedPlatform = platformId;
      _page = 1;
      _games.clear();
    });
    _loadGames();
  }

  void _navigateToGameDetail(Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameDetailScreen(game: game)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: _platforms.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: const Text('All Platforms'),
                    selected: _selectedPlatform == null,
                    onSelected: (_) => _onPlatformSelected(null),
                    backgroundColor: bgColor,
                    selectedColor: fgColor.withOpacity(0.2),
                    checkmarkColor: fgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: fgColor.withOpacity(0.3)),
                    ),
                    labelStyle: TextStyle(
                      color: _selectedPlatform == null
                          ? fgColor
                          : fgColor.withOpacity(0.7),
                    ),
                  ),
                );
              }
              final platform = _platforms[index - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: PlatformChip(
                  platform: platform,
                  isSelected: _selectedPlatform == platform.id.toString(),
                  onTap: () => _onPlatformSelected(platform.id.toString()),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: _hasError
              ? AppErrorWidget(
                  message: 'Failed to load upcoming games.',
                  onRetry: _loadInitialData,
                )
              : SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: (_games.isEmpty && _isLoading)
                      ? const LoadingShimmer()
                      : () {
                          final filteredGames = widget.searchQuery.isEmpty
                              ? _games
                              : _games
                                    .where(
                                      (game) =>
                                          game.name.toLowerCase().contains(
                                            widget.searchQuery.toLowerCase(),
                                          ),
                                    )
                                    .toList();

                          if (filteredGames.isEmpty && !_isLoading) {
                            return AppEmptyWidget(
                              subtitle: widget.searchQuery.isNotEmpty
                                  ? 'No results for your search.'
                                  : 'No upcoming games found for this platform.',
                            );
                          }

                          return ListView.builder(
                            itemCount:
                                filteredGames.length +
                                (_isLoading && widget.searchQuery.isEmpty
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index < filteredGames.length) {
                                return GameCard(
                                  game: filteredGames[index],
                                  onTap: () => _navigateToGameDetail(
                                    filteredGames[index],
                                  ),
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          );
                        }(),
                ),
        ),
      ],
    );
  }
}
