// lib/screens/reels_trailer_screen.dart

import 'package:buzzymovies/pexelapi.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

import '../models/video.dart';
import '../provider/movie_provider.dart';

class ReelsTrailerScreen extends StatefulWidget {
  @override
  _ReelsTrailerScreenState createState() => _ReelsTrailerScreenState();
}

class _ReelsTrailerScreenState extends State<ReelsTrailerScreen> {
  final PageController _pageController = PageController();
  List<Video> _videos = [];
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final videos = await PexelsApiService.fetchMovieTrailers();
    setState(() {
      _videos = videos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _videos.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _videos.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return VideoPlayerItem(
                  video: _videos[index],
                  pageIndex: index,
                  currentPageIndex: _currentPageIndex,
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class VideoPlayerItem extends StatefulWidget {
  final Video video;
  final int pageIndex;
  final int currentPageIndex;

  VideoPlayerItem({
    required this.video,
    required this.pageIndex,
    required this.currentPageIndex,
  });

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _videoPlayerController =
        VideoPlayerController.network(widget.video.videoUrl);
    await _videoPlayerController.initialize();
    if (widget.pageIndex == widget.currentPageIndex) {
      _videoPlayerController.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  void didUpdateWidget(VideoPlayerItem oldWidget) {
    if (widget.pageIndex == widget.currentPageIndex && !_isPlaying) {
      _videoPlayerController.play();
      setState(() {
        _isPlaying = true;
      });
    } else if (widget.pageIndex != widget.currentPageIndex && _isPlaying) {
      _videoPlayerController.pause();
      setState(() {
        _isPlaying = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
        _buildGradientOverlay(),
        _buildVideoInfo(),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Positioned(
      left: 10,
      right: 10,
      bottom: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.video.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.video.description,
            style: TextStyle(
              color: Colors.white70,
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<MovieProvider>(
            builder: (context, movieProvider, child) {
              final isFavorite = movieProvider.isFavorite(widget.video);
              return _buildActionButton(
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                onPressed: () {
                  movieProvider.toggleFavorite(widget.video);
                },
              );
            },
          ),
          SizedBox(height: 20),
          _buildActionButton(
            icon: Icons.share,
            onPressed: _shareVideo,
          ),
          SizedBox(height: 20),
          _buildActionButton(
            icon: _isPlaying ? Icons.pause : Icons.play_arrow,
            onPressed: () {
              setState(() {
                _isPlaying
                    ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
                _isPlaying = !_isPlaying;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 30),
        color: color,
        onPressed: onPressed,
      ),
    );
  }

  void _shareVideo() {
    final String shareText =
        '${widget.video.title}\n\nCheck out this video: ${widget.video.videoUrl}';
    Share.share(shareText, subject: 'Check out this video!');
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
