import 'package:koinonia/home_page/mostplayed.dart';

class ViewMovie {
  final int likecount;
  final String albumname;
  final String moviedescription;
  final String movieid;
  final String movieimage;
  final String movieyear;
  final String moviename;
  int isliked;

  final List<MostPlayedItem> mostplay;

  ViewMovie({
    required this.movieimage,
    required this.moviename,
    required this.moviedescription,
    required this.isliked,
    required this.likecount,
    required this.albumname,
    required this.mostplay,
    required this.movieid,
    required this.movieyear,
  });

  factory ViewMovie.fromJson(Map<String, dynamic> jsonMap) {
    var list = jsonMap['music_list'] as List;
    print(list.runtimeType);
    List<MostPlayedItem> imagesList =
        list.map((i) => MostPlayedItem.fromJson(i)).toList();

    return ViewMovie(
      isliked: jsonMap['is_liked'],
      likecount: jsonMap['like_count'],
      moviedescription: jsonMap['movie_description'],
      movieid: jsonMap['movie_id'],
      movieimage: jsonMap['movie_image'],
      movieyear: jsonMap['movie_year'],
      moviename: jsonMap['movie_name'],
      albumname: jsonMap['album_name'],
      mostplay: imagesList,
    );
  }
}
