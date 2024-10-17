// lib/screens/favorites_screen.dart

import 'package:buzzymovies/provider/movie_provider.dart';
import 'package:buzzymovies/widgets/movielist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/video.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Movies', icon: Icon(Icons.movie)),
              Tab(text: 'Videos', icon: Icon(Icons.video_library)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMoviesTab(),
            _buildVideosTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviesTab() {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.favorites.isEmpty) {
          return Center(child: Text('No favorite movies yet.'));
        }
        return MovieListWidget(movies: movieProvider.favorites);
      },
    );
  }

  Widget _buildVideosTab() {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.favoriteVideos.isEmpty) {
          return Center(child: Text('No favorite videos yet.'));
        }
        return ListView.builder(
          itemCount: movieProvider.favoriteVideos.length,
          itemBuilder: (context, index) {
            final video = movieProvider.favoriteVideos[index];
            return _buildVideoItem(context, video);
          },
        );
      },
    );
  }

  Widget _buildVideoItem(BuildContext context, Video video) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          video.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(video.title),
      subtitle: Text(video.description),
      trailing: IconButton(
        icon: Icon(Icons.favorite, color: Colors.red),
        onPressed: () {
          context.read<MovieProvider>().toggleFavorite(video);
        },
      ),
      onTap: () {
        // TODO: Implement video playback or navigation to video detail screen
      },
    );
  }
}
