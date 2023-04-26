class ViewArtistItem {
  final String artistId;
  final String artistCategory;
  final String artistName;
  final String artistImage;
  final int? isLiked;
  final int? likeCount;

  ViewArtistItem({
    required this.artistId,
    required this.artistCategory,
    required this.artistName,
    required this.artistImage,
    this.isLiked,
    this.likeCount,
  });

  ViewArtistItem.fromJson(Map<String, dynamic> json)
      : artistId = json['artist_id'] as String,
        artistCategory = json['artist_category'] as String,
        artistName = json['artist_name'] as String,
        artistImage = json['artist_image'] as String,
        isLiked = json['is_liked'] as int?,
        likeCount = json['like_count'] as int?;

  Map<String, dynamic> toJson() => {
        'artist_id': artistId,
        'artist_name': artistName,
        'artist_image': artistImage,
        'is_liked': isLiked,
        'artist_category': artistCategory,
        'like_count': likeCount
      };
}
