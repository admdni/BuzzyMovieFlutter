// lib/models/video.dart

class Video {
  final int id;
  final String videoUrl;
  final String image;
  final String title;
  final String description;

  Video({
    required this.id,
    required this.videoUrl,
    required this.image,
    required this.title,
    required this.description,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    final videoFiles = json['video_files'] as List;
    final hdVideo = videoFiles.firstWhere(
      (file) => file['quality'] == 'hd',
      orElse: () => videoFiles.first,
    );

    String formatTitle(String url) {
      final parts = url.split('/');
      if (parts.isNotEmpty) {
        return parts.last
            .replaceAll('-', ' ')
            .split(' ')
            .map((word) => word.capitalize())
            .join(' ');
      }
      return '';
    }

    return Video(
      id: json['id'],
      videoUrl: hdVideo['link'],
      image: json['image'],
      title: formatTitle(json['url']),
      description: json['user']['name'],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  }
}
