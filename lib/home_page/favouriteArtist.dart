class FavouriteArtist {
  String? status;
  String? message;
  String? response;

  static List<FavouriteArtistItem>? favList;

  FavouriteArtist.getuserid(dynamic obj) {
    favList = obj
        .map<FavouriteArtistItem>(
            (json) => new FavouriteArtistItem.fromJson(json))
        .toList();
  }
}

class FavouriteArtistItem {
  final String artistid;
  final String artistname;
  final String artistimage;
  final String likedCount;
  int isliked;

  FavouriteArtistItem({
    required this.artistid,
    required this.artistname,
    required this.artistimage,
    required this.likedCount,
    required this.isliked,
  });

  factory FavouriteArtistItem.fromJson(Map<String, dynamic> jsonMap) {
    return FavouriteArtistItem(
      artistid: jsonMap['artist_id'],
      artistname: jsonMap['artist_name'],
      artistimage: jsonMap['artist_image'],
      likedCount: jsonMap['likedCount'],
      isliked: jsonMap['is_liked'],
    );
  }
}
