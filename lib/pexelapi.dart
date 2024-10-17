// lib/services/pexels_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video.dart';

class PexelsApiService {
  static const String apiKey = '';
  static const String baseUrl = 'https://api.pexels.com/videos';

  static Future<List<Video>> fetchVideos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/search?query=movie+trailer&per_page=20'),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> videos = data['videos'];
      return videos.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  static Future<List<Video>> fetchMovieTrailers() async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/search?query=movie+cartoon+anime+animation+action+drama&per_page=100'),
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> videos = data['videos'];
      return videos.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
