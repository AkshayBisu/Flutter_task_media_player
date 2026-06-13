
enum MediaType { image, video }

class MediaItem {
  final MediaType type;
  final String url;

  const MediaItem({required this.type, required this.url});

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    final rawType = json['type'] as String;
    return MediaItem(
      type: rawType == 'video' ? MediaType.video : MediaType.image,
      url: json['url'] as String,
    );
  }
}
