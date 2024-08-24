class Song {
  final String id;
  final String title;
  final String album;
  final String artist;
  final String source;
  final String image;
  final int duration;
  final bool favorite;
  final int counter;
  final int replay;

  Song({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.source,
    required this.image,
    required this.duration,
    required this.favorite,
    required this.counter,
    required this.replay,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as String,
      title: json['title'] as String,
      album: json['album'] as String,
      artist: json['artist'] as String,
      source: json['source'] as String,
      image: json['image'] as String,
      duration: json['duration'] as int,
      favorite: json['favorite'] == 'true',
      counter: json['counter'] as int,
      replay: json['replay'] as int,
    );
  }
}
