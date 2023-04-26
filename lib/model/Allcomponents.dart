class AllComponents {
  String? status;
  String? message;
  String? response;

  static List<AllComponentsItem>? list;

  AllComponents.getuserid(dynamic obj) {
    list = obj
        .map<AllComponentsItem>((json) => new AllComponentsItem.fromJson(json))
        .toList();
  }
}

class AllComponentsItem {
  final String homecomponentsid;
  final String homecomponentsname;
  final String homecomponentsorder;
  final String homecomponentssliderallowed;

  AllComponentsItem(
      {required this.homecomponentsid,
      required this.homecomponentsname,
      required this.homecomponentsorder,
      required this.homecomponentssliderallowed});

  factory AllComponentsItem.fromJson(Map<String, dynamic> jsonMap) {
    return AllComponentsItem(
      homecomponentsid: jsonMap['home_components_id'],
      homecomponentsname: jsonMap['home_components_name'],
      homecomponentsorder: jsonMap['home_components_order'],
      homecomponentssliderallowed: jsonMap['home_components_slider_allowed'],
    );
  }
}
