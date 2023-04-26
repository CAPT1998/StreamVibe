class Albummodel {
  final String albumId;
  final String artistId;
  final String albumartistname;

  final String albumName;
  final String albumImage;
  final int isLiked;
  final int? likeCount;

  Albummodel({
    required this.albumId,
    required this.artistId,
    required this.albumartistname,
    required this.albumName,
    required this.albumImage,
    required this.isLiked,
    this.likeCount,
  });

  Albummodel.fromJson(Map<String, dynamic> json)
      : albumId = json['album_id'] as String,
        artistId = json['artist_id'] as String,
        albumartistname = json['artist_name_album'] as String,
        albumName = json['album_name'] as String,
        albumImage = json['album_image'] as String,
        isLiked = json['is_liked'] as int,
        likeCount = json['like_count'] as int?;

  Map<String, dynamic> toJson() => {
        'album_id': albumId,
        'artist_id': artistId,
        'artist_name_album': albumartistname,
        'album_name': albumName,
        'album_image': albumImage,
        'is_liked': isLiked,
        'like_count': likeCount
      };
}
