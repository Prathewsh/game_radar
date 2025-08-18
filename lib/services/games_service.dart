import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamesradar/models/platform.dart';
import 'package:gamesradar/models/game.dart';

class GamesService {
  static final String _apiKey = dotenv.env['RAWG_API_KEY']!;
  static const String _baseUrl = 'https://api.rawg.io/api';
  static const int _cacheDurationMinutes = 30;

  // Memory cache for platforms
  List<Platform>? _cachedPlatforms;
  DateTime? _platformsCacheTime;

  // Memory cache for games
  final Map<String, List<Game>> _cachedGames = {};
  final Map<String, DateTime> _gamesCacheTime = {};

  Future<List<Platform>> getPlatforms({bool forceRefresh = false}) async {
    // Return cached data if still valid
    if (!forceRefresh &&
        _cachedPlatforms != null &&
        _platformsCacheTime != null &&
        DateTime.now().difference(_platformsCacheTime!) <
            const Duration(minutes: _cacheDurationMinutes)) {
      return _cachedPlatforms!;
    }

    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/platforms?page_size=50&key=$_apiKey'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final platforms = (data['results'] as List)
            .map((json) => Platform.fromJson(json))
            .toList();

        // Update cache
        _cachedPlatforms = platforms;
        _platformsCacheTime = DateTime.now();

        return platforms;
      } else {
        throw _handleError(response.statusCode, 'platforms');
      }
    } catch (e) {
      // Return cached data if available, even if stale
      if (_cachedPlatforms != null) return _cachedPlatforms!;
      throw Exception('Failed to load platforms: ${e.toString()}');
    }
  }

  Future<List<Game>> getUpcomingGames({
    int page = 1,
    String platforms = '',
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'upcoming_$platforms';
    return _getGames(
      endpoint: 'games',
      params: 'dates=${_getCurrentDate()},2100-01-01&ordering=released',
      page: page,
      platforms: platforms,
      cacheKey: cacheKey,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Game>> getNewReleases({
    int page = 1,
    String platforms = '',
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'newreleases_$platforms';
    return _getGames(
      endpoint: 'games',
      params: 'dates=2020-01-01,${_getCurrentDate()}&ordering=-released',
      page: page,
      platforms: platforms,
      cacheKey: cacheKey,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Game>> getGamesByPlatform({
    required int platformId,
    int page = 1,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'platform_$platformId';
    return _getGames(
      endpoint: 'games',
      params: 'platforms=$platformId',
      page: page,
      cacheKey: cacheKey,
      forceRefresh: forceRefresh,
    );
  }

  Future<Game?> getGameDetails(int id, {bool forceRefresh = false}) async {
    final cacheKey = 'game_$id';

    // Return cached data if still valid
    if (!forceRefresh &&
        _cachedGames.containsKey(cacheKey) &&
        _gamesCacheTime.containsKey(cacheKey) &&
        DateTime.now().difference(_gamesCacheTime[cacheKey]!) <
            const Duration(minutes: _cacheDurationMinutes)) {
      return _cachedGames[cacheKey]!.first;
    }

    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/games/$id?key=$_apiKey'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final game = Game.fromJson(json.decode(response.body));

        // Update cache
        _cachedGames[cacheKey] = [game];
        _gamesCacheTime[cacheKey] = DateTime.now();

        return game;
      } else {
        throw _handleError(response.statusCode, 'game details');
      }
    } catch (e) {
      // Return cached data if available
      if (_cachedGames.containsKey(cacheKey)) {
        return _cachedGames[cacheKey]!.first;
      }
      throw Exception('Failed to load game details: ${e.toString()}');
    }
  }

  Future<List<Game>> searchGames(String query, {int page = 1}) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/games?search=$query&page_size=20&page=$page&key=$_apiKey',
            ),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return _parseGameResponse(response);
      } else {
        throw _handleError(response.statusCode, 'search results');
      }
    } catch (e) {
      throw Exception('Failed to search games: ${e.toString()}');
    }
  }

  // Helper methods
  Future<List<Game>> _getGames({
    required String endpoint,
    required String params,
    required String cacheKey,
    int page = 1,
    String platforms = '',
    bool forceRefresh = false,
  }) async {
    // Return cached data if still valid
    if (!forceRefresh &&
        _cachedGames.containsKey(cacheKey) &&
        _gamesCacheTime.containsKey(cacheKey) &&
        DateTime.now().difference(_gamesCacheTime[cacheKey]!) <
            const Duration(minutes: _cacheDurationMinutes)) {
      return _cachedGames[cacheKey]!;
    }

    try {
      final platformParam = platforms.isNotEmpty ? '&platforms=$platforms' : '';
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/$endpoint?$params&page_size=20&page=$page$platformParam&key=$_apiKey',
            ),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final games = _parseGameResponse(response);

        // Update cache
        _cachedGames[cacheKey] = games;
        _gamesCacheTime[cacheKey] = DateTime.now();

        return games;
      } else {
        throw _handleError(response.statusCode, 'games');
      }
    } catch (e) {
      // Return cached data if available
      if (_cachedGames.containsKey(cacheKey)) return _cachedGames[cacheKey]!;
      throw Exception('Failed to load games: ${e.toString()}');
    }
  }

  List<Game> _parseGameResponse(http.Response response) {
    final data = json.decode(response.body);
    return (data['results'] as List)
        .map((json) => Game.fromJson(json))
        .toList();
  }

  Exception _handleError(int statusCode, String resource) {
    if (statusCode == 401) {
      return Exception('Invalid API key - please check your .env file');
    } else if (statusCode == 404) {
      return Exception('$resource not found');
    } else if (statusCode >= 500) {
      return Exception('Server error - please try again later');
    } else {
      return Exception('Failed to load $resource (status $statusCode)');
    }
  }

  String _getCurrentDate() => DateTime.now().toString().split(' ')[0];
}
