// lib/screens/trailer_screen.dart

import 'package:buzzymovies/api.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailerScreen extends StatefulWidget {
  final int movieId;

  TrailerScreen({required this.movieId});

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late Future<String> _trailerKey;

  @override
  void initState() {
    super.initState();
    _trailerKey = ApiService.fetchMovieTrailer(widget.movieId);
  }

  Future<void> _launchYouTubeVideo(String videoId) async {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Trailer')),
      body: FutureBuilder<String>(
        future: _trailerKey,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final trailerKey = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _launchYouTubeVideo(trailerKey),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          'https://img.youtube.com/vi/$trailerKey/0.jpg',
                          height: 200,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                        Icon(
                          Icons.play_circle_outline,
                          size: 64,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _launchYouTubeVideo(trailerKey),
                    child: Text('Watch on YouTube'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No trailer available'));
          }
        },
      ),
    );
  }
}
