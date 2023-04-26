class Getplaylistmodel {
  final String userPlaylistId;
  final String userPlaylistName;
  final int musicCount;
  final List<Images> images;

  Getplaylistmodel({
    required this.userPlaylistId,
    required this.userPlaylistName,
    required this.musicCount,
    required this.images,
  });

  Getplaylistmodel.fromJson(Map<String, dynamic> json)
      : userPlaylistId = json['user_playlist_id'] as String,
        userPlaylistName = json['user_playlist_name'] as String,
        musicCount = json['music_count'] as int,
        images = (json['images'] as List?)!
            .map((dynamic e) => Images.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'user_playlist_id': userPlaylistId,
        'user_playlist_name': userPlaylistName,
        'music_count': musicCount,
        'images': images.map((e) => e.toJson()).toList()
      };
}

class Images {
  final String musicImage;

  Images({
    required this.musicImage,
  });

  Images.fromJson(Map<String, dynamic> json)
      : musicImage = json['music_image'] as String;

  Map<String, dynamic> toJson() => {'music_image': musicImage};
}
