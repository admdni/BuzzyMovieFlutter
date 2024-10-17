// lib/widgets/movie_categories_widget.dart

import 'package:buzzymovies/provider/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieCategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movieProvider.categories.length,
        itemBuilder: (context, index) {
          final category = movieProvider.categories[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () {
                movieProvider.fetchMoviesByCategory(category);
              },
              child: Text(_formatCategoryName(category)),
            ),
          );
        },
      ),
    );
  }

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
