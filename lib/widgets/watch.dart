import 'package:buzzymovies/provider/movie_provider.dart';
import 'package:buzzymovies/widgets/movielist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watch List')),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          return MovieListWidget(movies: movieProvider.watchList);
        },
      ),
    );
  }
}
