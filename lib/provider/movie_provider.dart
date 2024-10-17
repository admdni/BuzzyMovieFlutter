// lib/provider/movie_provider.dart

import 'package:buzzymovies/api.dart';
import 'package:buzzymovies/models/cast.dart';
import 'package:buzzymovies/models/video.dart';
import 'package:buzzymovies/storage.dart';
import 'package:flutter/foundation.dart';

import '../models/movie.dart';
import '../models/genre.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _favorites = [];
  List<Movie> _watchList = [];
  List<Genre> _genres = [];
  List<Video> _favoriteVideos = [];
  String _currentCategory = 'popular';
  bool _isLoading = false;
  String? _error;

  List<Movie> get movies => _movies;
  List<Movie> get favorites => _favorites;
  List<Movie> get watchList => _watchList;
  List<Genre> get genres => _genres;
  List<Video> get favoriteVideos => _favoriteVideos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final List<String> categories = [
    'popular',
    'top_rated',
    'upcoming',
    'now_playing'
  ];

  Future<void> fetchMoviesByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedMovies = await ApiService.fetchMovies(category);
      _movies = fetchedMovies;
      _currentCategory = category;
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error in MovieProvider.fetchMoviesByCategory: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGenres() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _genres = await ApiService.fetchGenres();
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error in MovieProvider.fetchGenres: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoviesByGenre(int genreId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedMovies = await ApiService.fetchMoviesByGenre(genreId);
      _movies = fetchedMovies;
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error in MovieProvider.fetchMoviesByGenre: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final searchResults = await ApiService.searchMovies(query);
      _movies = searchResults;
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Error in MovieProvider.searchMovies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    try {
      final favoriteIds = await StorageService.getFavorites();
      _favorites =
          _movies.where((movie) => favoriteIds.contains(movie.id)).toList();
      notifyListeners();
    } catch (error) {
      print('Error loading favorites: $error');
      _error = 'Failed to load favorites';
      notifyListeners();
    }
  }

  Future<void> loadWatchList() async {
    try {
      final watchListIds = await StorageService.getWatchList();
      _watchList =
          _movies.where((movie) => watchListIds.contains(movie.id)).toList();
      notifyListeners();
    } catch (error) {
      print('Error loading watch list: $error');
      _error = 'Failed to load watch list';
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(dynamic item) async {
    if (item is Movie) {
      try {
        final isExist = _favorites.contains(item);
        if (isExist) {
          _favorites.remove(item);
          await StorageService.removeFavorite(item.id);
        } else {
          _favorites.add(item);
          await StorageService.saveFavorite(item.id);
        }
        notifyListeners();
      } catch (error) {
        print('Error toggling favorite movie: $error');
        _error = 'Failed to update favorites';
        notifyListeners();
      }
    } else if (item is Video) {
      final isExist = _favoriteVideos.contains(item);
      if (isExist) {
        _favoriteVideos.remove(item);
      } else {
        _favoriteVideos.add(item);
      }
      notifyListeners();
    }
  }

  Future<void> toggleWatchList(Movie movie) async {
    try {
      final isExist = _watchList.contains(movie);
      if (isExist) {
        _watchList.remove(movie);
        await StorageService.removeFromWatchList(movie.id);
      } else {
        _watchList.add(movie);
        await StorageService.saveToWatchList(movie.id);
      }
      notifyListeners();
    } catch (error) {
      print('Error toggling watch list: $error');
      _error = 'Failed to update watch list';
      notifyListeners();
    }
  }

  bool isFavorite(dynamic item) {
    if (item is Movie) {
      return _favorites.contains(item);
    } else if (item is Video) {
      return _favoriteVideos.contains(item);
    }
    return false;
  }

  bool isInWatchList(Movie movie) {
    return _watchList.contains(movie);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    try {
      return await ApiService.fetchMovieDetails(movieId);
    } catch (e) {
      print('Error fetching movie details: $e');
      _error = 'Failed to fetch movie details';
      notifyListeners();
      rethrow;
    }
  }

  Future<String> fetchMovieTrailer(int movieId) async {
    try {
      return await ApiService.fetchMovieTrailer(movieId);
    } catch (e) {
      print('Error fetching movie trailer: $e');
      _error = 'Failed to fetch movie trailer';
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Cast>> fetchMovieCast(int movieId) async {
    try {
      return await ApiService.fetchMovieCast(movieId);
    } catch (e) {
      print('Error fetching movie cast: $e');
      return [];
    }
  }
}
