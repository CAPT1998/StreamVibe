class Searches {
  String? status;
  String? message;
  String? response;

  static List<SearchesItem>? searchlist;

  Searches.getuserid(dynamic obj) {
    searchlist = obj
        .map<SearchesItem>((json) => new SearchesItem.fromJson(json))
        .toList();
  }
}

class SearchesItem {
  final String searchtype;
  final String id;
  final String searchtext;

  SearchesItem(
      {required this.searchtext, required this.id, required this.searchtype});

  factory SearchesItem.fromJson(Map<String, dynamic> jsonMap) {
    return SearchesItem(
        searchtext: jsonMap['search_text'],
        id: jsonMap['id'],
        searchtype: jsonMap['search_type']);
  }
}
