class MostPlayed {
  String? status;
  String? message;
  String? response;

  static List<MostPlayedItem>? homemostplaylist;

  MostPlayed.getuserid(dynamic obj) {
    homemostplaylist = obj
        .map<MostPlayedItem>((json) => new MostPlayedItem.fromJson(json))
        .toList();
  }
}

class MostPlayedItem {
  final String musictitle;
  final String musicid;
  final String artistid;
  final String albumid;
  final String musicfile;
  final String musicimage;
  final String musicduration;
  final String playCount;
  int isinplaylist;
  int isliked;
  final int likecount;
  final String albumname;
  final List<Artists> artistlist;

  MostPlayedItem({
    required this.musicid,
    required this.musictitle,
    required this.musicimage,
    required this.musicduration,
    required this.musicfile,
    required this.isliked,
    required this.likecount,
    required this.albumname,
    required this.artistlist,
    required this.artistid,
    required this.isinplaylist,
    required this.albumid,
    required this.playCount,
  });

  factory MostPlayedItem.fromJson(Map<String, dynamic> jsonMap) {
    var list = jsonMap['artists'] as List;
    // print(list.runtimeType);
    List<Artists> imagesList = list.map((i) => Artists.fromJson(i)).toList();

    return MostPlayedItem(
        musicduration: jsonMap['music_duration'],
        isliked: jsonMap['is_liked'],
        musicfile: jsonMap['music_file'],
        musicimage: jsonMap['music_image'],
        likecount: jsonMap['like_count'],
        musicid: jsonMap['music_id'],
        artistid: jsonMap['artist_id'],
        isinplaylist: jsonMap['is_in_playlist'],
        albumid: jsonMap['album_id'],
        playCount: jsonMap['playCount'],
        albumname: jsonMap['album_name'],
        artistlist: imagesList,
        musictitle: jsonMap['music_title']);
  }
}

class Artists {
  final String artistname;
  final String artistid;

  Artists({required this.artistname, required this.artistid});

  factory Artists.fromJson(Map<String, dynamic> jsonMap) {
    return Artists(
        artistname: jsonMap['artist_name'], artistid: jsonMap['artist_id']);
  }
}
