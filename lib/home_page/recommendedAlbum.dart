class RecommendedAlbum {
  String? status;
  String? message;
  String? response;

  static List<RecommendedAlbumItem>? albumList;

  RecommendedAlbum.getuserid(dynamic obj) {
    albumList = obj
        .map<RecommendedAlbumItem>(
            (json) => new RecommendedAlbumItem.fromJson(json))
        .toList();
  }
}

class RecommendedAlbumItem {
  final String albumid;
  final String albumname;
  final String albumimage;
  final String likedCount;
  final int isliked;

  RecommendedAlbumItem(
      {required this.albumid,
      required this.albumimage,
      required this.albumname,
      required this.isliked,
      required this.likedCount});

  factory RecommendedAlbumItem.fromJson(Map<String, dynamic> jsonMap) {
    return RecommendedAlbumItem(
      albumid: jsonMap['album_id'],
      albumimage: jsonMap['album_image'],
      albumname: jsonMap['album_name'],
      isliked: jsonMap['is_liked'],
      likedCount: jsonMap['likedCount'],
    );
  }
}
