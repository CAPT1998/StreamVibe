class Categorymodel {
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  final String parentCategoryId;
  final String categoryStatus;
  final String createdDate;
  final List<dynamic>? subcategory;

  Categorymodel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.parentCategoryId,
    required this.categoryStatus,
    required this.createdDate,
    required this.subcategory,
  });

  Categorymodel.fromJson(Map<String, dynamic> json)
      : categoryId = json['category_id'] as String,
        categoryName = json['category_name'] as String,
        categoryImage = json['category_image'] as String,
        parentCategoryId = json['parent_category_id'] as String,
        categoryStatus = json['category_status'] as String,
        createdDate = json['created_date'] as String,
        subcategory = json['subcategory'] as List;

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'category_name': categoryName,
        'category_image': categoryImage,
        'parent_category_id': parentCategoryId,
        'category_status': categoryStatus,
        'created_date': createdDate,
        'subcategory': subcategory
      };
}
