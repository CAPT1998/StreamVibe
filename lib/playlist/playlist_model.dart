class Getplaylistmodel {
  final String userPlaylistId;
  final String userPlaylistName;
  final String userPlaylistImage;
  final int musicCount;
  final List<Images> imagesslist;

  Getplaylistmodel({
    required this.userPlaylistId,
    required this.userPlaylistName,
    required this.userPlaylistImage,
    required this.musicCount,
    required this.imagesslist,
  });

  Getplaylistmodel.fromJson(Map<String, dynamic> json)
      : userPlaylistId = json['user_playlist_id'] as String,
        userPlaylistName = json['user_playlist_name'] as String,
        userPlaylistImage = json['user_playlist_image'] as String,
        musicCount = json['music_count'] as int,
        imagesslist = (json['images'] as List?)!
            .map((dynamic e) => Images.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'user_playlist_id': userPlaylistId,
        'user_playlist_name': userPlaylistName,
        'user_playlist_image': userPlaylistImage,
        'music_count': musicCount,
        'images': imagesslist.map((e) => e.toJson()).toList()
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
