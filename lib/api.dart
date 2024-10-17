// lib/services/api_service.dart

import 'dart:convert';
import 'package:buzzymovies/models/cast.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/genre.dart';

class ApiService {
  static const String apiKey = '';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<Movie>> fetchMovies(String category) async {
    final url = Uri.parse(
        '$baseUrl/movie/$category?api_key=$apiKey&language=en-US&page=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchMovies: $e');
      throw Exception('Failed to load movies: $e');
    }
  }

  static Future<List<Genre>> fetchGenres() async {
    final url =
        Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> genres = data['genres'];
        return genres.map((json) => Genre.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load genres: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchGenres: $e');
      throw Exception('Failed to load genres: $e');
    }
  }

  static Future<List<Movie>> fetchMoviesByGenre(int genreId) async {
    final url = Uri.parse(
        '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId&language=en-US&page=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load movies by genre: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchMoviesByGenre: $e');
      throw Exception('Failed to load movies by genre: $e');
    }
  }

  static Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse(
        '$baseUrl/search/movie?api_key=$apiKey&language=en-US&query=$query&page=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in searchMovies: $e');
      throw Exception('Failed to search movies: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final url =
        Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=en-US');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchMovieDetails: $e');
      throw Exception('Failed to load movie details: $e');
    }
  }

  static Future<String> fetchMovieTrailer(int movieId) async {
    final url = Uri.parse(
        '$baseUrl/movie/$movieId/videos?api_key=$apiKey&language=en-US');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final trailers =
            results.where((video) => video['type'] == 'Trailer').toList();
        if (trailers.isNotEmpty) {
          return trailers.first['key'];
        } else {
          throw Exception('No trailer found for this movie');
        }
      } else {
        throw Exception('Failed to load movie trailer: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchMovieTrailer: $e');
      throw Exception('Failed to load movie trailer: $e');
    }
  }

  static Future<List<Cast>> fetchMovieCast(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> cast = data['cast'];
        return cast.map((json) => Cast.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movie cast: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchMovieCast: $e');
      throw Exception('Failed to load movie cast: $e');
    }
  }
}
