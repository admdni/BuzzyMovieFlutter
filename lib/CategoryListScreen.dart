// lib/screens/category_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';
import '../widgets/movielist.dart';
import '../models/genre.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MovieProvider>().fetchGenres());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Genres'),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (movieProvider.error != null) {
            return Center(child: Text(movieProvider.error!));
          } else {
            return GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: movieProvider.genres.length,
              itemBuilder: (context, index) {
                Genre genre = movieProvider.genres[index];
                return GenreCard(genre: genre);
              },
            );
          }
        },
      ),
    );
  }
}

class GenreCard extends StatelessWidget {
  final Genre genre;

  GenreCard({required this.genre});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenreMoviesScreen(genre: genre),
            ),
          );
        },
        child: Center(
          child: Text(
            genre.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class GenreMoviesScreen extends StatefulWidget {
  final Genre genre;

  GenreMoviesScreen({required this.genre});

  @override
  _GenreMoviesScreenState createState() => _GenreMoviesScreenState();
}

class _GenreMoviesScreenState extends State<GenreMoviesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MovieProvider>().fetchMoviesByGenre(widget.genre.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genre.name),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (movieProvider.error != null) {
            return Center(child: Text(movieProvider.error!));
          } else {
            return MovieListWidget(movies: movieProvider.movies);
          }
        },
      ),
    );
  }
}
