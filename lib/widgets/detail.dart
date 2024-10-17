// lib/screens/movie_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/movie_provider.dart';
import '../widgets/trailer.dart';
import '../models/movie.dart';
import '../models/cast.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailScreen({required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<List<Cast>> _castFuture;

  @override
  void initState() {
    super.initState();
    _castFuture = context.read<MovieProvider>().fetchMovieCast(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'movie_poster_${widget.movie.id}',
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movie.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Release Date: ${widget.movie.releaseDate}'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 4),
                      Text('${widget.movie.voteAverage}/10'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Overview',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(widget.movie.overview),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<MovieProvider>()
                              .toggleFavorite(widget.movie);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context
                                      .read<MovieProvider>()
                                      .isFavorite(widget.movie)
                                  ? 'Added to Favorites'
                                  : 'Removed from Favorites'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(Icons.favorite),
                        label: Text('Favorite'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<MovieProvider>()
                              .toggleWatchList(widget.movie);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context
                                      .read<MovieProvider>()
                                      .isInWatchList(widget.movie)
                                  ? 'Added to Watch List'
                                  : 'Removed from Watch List'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(Icons.watch_later),
                        label: Text('Watch List'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TrailerScreen(movieId: widget.movie.id),
                        ),
                      );
                    },
                    child: Text('Watch Trailer'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Cast',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  FutureBuilder<List<Cast>>(
                    future: _castFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error loading cast');
                      } else if (snapshot.hasData) {
                        return SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final cast = snapshot.data![index];
                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(cast.name,
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Text('No cast information available');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
