class Downloads {
  final int isallowdownloads;

  Downloads({required this.isallowdownloads});

  factory Downloads.fromJson(Map<String, dynamic> jsonMap) {
    return Downloads(
      isallowdownloads: jsonMap['is_allow_downloads'],
    );
  }
}
