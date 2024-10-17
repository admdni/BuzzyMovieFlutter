// lib/screens/home_screen.dart

import 'package:buzzymovies/news.dart';
import 'package:buzzymovies/reels.dart';
import 'package:buzzymovies/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';
import '../widgets/categories.dart';
import '../widgets/favorite.dart';
import '../widgets/movielist.dart';
import '../widgets/slider.dart';
import '../widgets/watch.dart';

import '../models/genre.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    MovieListPage(),
    MovieNewsScreen(),
    ReelsTrailerScreen(),
    FavoritesScreen(),
    WatchListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieProvider>().fetchMoviesByCategory('popular');
      context.read<MovieProvider>().fetchGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buzzy Movies App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovieSearchScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 143, 41, 41),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.podcasts),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Trailers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: 'Watch List',
          ),
        ],
      ),
    );
  }
}

class MovieListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (movieProvider.error != null) {
          return Center(child: Text(movieProvider.error!));
        } else {
          return Column(
            children: [
              MovieSliderWidget(movies: movieProvider.movies.take(5).toList()),
              SizedBox(height: 16),
              MovieCategoriesWidget(),
              Expanded(
                child: MovieListWidget(movies: movieProvider.movies),
              ),
              CategoryButtonsWidget(),
            ],
          );
        }
      },
    );
  }
}

class CategoryButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.genres.isEmpty) {
          return SizedBox
              .shrink(); // Don't show anything if genres are not loaded
        }
        return Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieProvider.genres.length,
            itemBuilder: (context, index) {
              final genre = movieProvider.genres[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenreMoviesScreen(genre: genre),
                      ),
                    );
                  },
                  child: Text(genre.name),
                ),
              );
            },
          ),
        );
      },
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
