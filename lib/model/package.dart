class Packages {
  String? status;
  String? message;
  String? response;

  static List<PackagesItem> myPackgelist = [];

  Packages.getuserid(dynamic obj) {
    myPackgelist = obj
        .map<PackagesItem>((json) => new PackagesItem.fromJson(json))
        .toList();
  }
}

class PackagesItem {
  final String packageid;
  final String packagename;
  final String packageduration;
  final String packageprice;
  final String totalpackageprice;

  PackagesItem(
      {required this.packageid,
      required this.packagename,
      required this.packageduration,
      required this.packageprice,
      required this.totalpackageprice});

  factory PackagesItem.fromJson(Map<String, dynamic> jsonMap) {
    return PackagesItem(
      packageprice: jsonMap['package_price'],
      totalpackageprice: jsonMap['total_package_price'],
      packageid: jsonMap['package_id'],
      packageduration: jsonMap['package_duration'],
      packagename: jsonMap['package_name'],
    );
  }
}
