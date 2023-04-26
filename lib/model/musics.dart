class Musics {
  final String musicId;
  final String? artistId;
  final String? albumId;
  final String? movieId;
  final String? categoryId;
  final String musicTitle;
  final String musicFile;
  final String musicImage;
  final String? musicDuration;
  final String? albumName;
  final String categoryName;
  final String movieName;
  final int? isLiked;
  final int? isInPlaylist;
  final int? likeCount;
  bool isPlayed;

  final List<Artists>? artists;

  Musics({
    required this.musicId,
    this.artistId,
    this.albumId,
    this.movieId,
    this.categoryId,
    required this.musicTitle,
    required this.musicFile,
    required this.musicImage,
    this.isPlayed = false,
    this.musicDuration,
     this.albumName,
    required this.categoryName,
    required this.movieName,
    this.isLiked,
    this.isInPlaylist,
    this.likeCount,
    this.artists,
  });

  Musics.fromJson(Map<String, dynamic> json)
      : musicId = json['music_id'] as String,
        artistId = json['artist_id'] as String?,
        albumId = json['album_id'] as String?,
        movieId = json['movie_id'] as String?,
        categoryId = json['category_id'] as String?,
        musicTitle = json['music_title'] as String,
        musicFile = json['music_file'] as String,
        musicImage = json['music_image'] as String,
        musicDuration = json['music_duration'] as String?,
        albumName = json['album_name'] as String?,
        categoryName = json['category_name']??"" as String,
        movieName = json['movie_name']??"" as String,
        isLiked = json['is_liked'] as int?,
        isPlayed = false,
        isInPlaylist = json['is_in_playlist'] as int?,
        likeCount = json['like_count'] as int?,
        artists = (json['artists'] as List?)
            ?.map((dynamic e) => Artists.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'music_id': musicId,
        'artist_id': artistId,
        'album_id': albumId,
        'movie_id': movieId,
        'category_id': categoryId,
        'isPlayed': isPlayed,
        'music_title': musicTitle,
        'music_file': musicFile,
        'music_image': musicImage,
        'music_duration': musicDuration,
        'album_name': albumName,
        'category_name': categoryName,
        'movie_name': movieName,
        'is_liked': isLiked,
        'is_in_playlist': isInPlaylist,
        'like_count': likeCount,
        'artists': artists?.map((e) => e.toJson()).toList()
      };

  Musics copyWith(
      {String? id,
      String? title,
      String? artist,
      String? url,
      String? userId,
      String? musicImage}) {
    return Musics(
      musicId: id ?? this.musicId,
      musicTitle: title ?? this.musicTitle,
      movieName: artist ?? this.movieName,
      musicFile: url ?? this.musicFile,
      musicImage: musicImage ?? this.musicImage,
      categoryId: userId ?? this.categoryId,
      albumName: '',
      categoryName: '',
    );
  }
}

class Artists {
  final String artistId;
  final String artistName;

  Artists({
    required this.artistId,
    required this.artistName,
  });

  Artists.fromJson(Map<String, dynamic> json)
      : artistId = json['artist_id'] as String,
        artistName = json['artist_name'] as String;

  Map<String, dynamic> toJson() =>
      {'artist_id': artistId, 'artist_name': artistName};
}
