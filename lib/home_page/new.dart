class AllAlbum {
  String? status;
  String? message;
  String? response;

  static List<AllAlbumItem>? popalbumlist;

  AllAlbum.getuserid(dynamic obj) {
    popalbumlist = obj
        .map<AllAlbumItem>((json) => new AllAlbumItem.fromJson(json))
        .toList();
  }
}

class AllAlbumItem {
  final String albumid;
  final String albumname;
  final String albumimage;
  final int isliked;
  final int likecount;

  AllAlbumItem({
    required this.albumid,
    required this.albumname,
    required this.albumimage,
    required this.isliked,
    required this.likecount,
  });

  factory AllAlbumItem.fromJson(Map<String, dynamic> jsonMap) {
    return AllAlbumItem(
      albumid: jsonMap['album_id'],
      albumname: jsonMap['album_name'],
      albumimage: jsonMap['album_image'],
      isliked: jsonMap['is_liked'],
      likecount: jsonMap['like_count'],
    );
  }
}
