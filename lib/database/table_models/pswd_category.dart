class PswdCategory {
  final int? pswdCategoryNo;
  final String categoryName;

  PswdCategory({
    this.pswdCategoryNo,
    required this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'pswd_category_no': pswdCategoryNo,
      'category_name': categoryName,
    };
  }

  factory PswdCategory.fromMap(Map<String, dynamic> map) {
    return PswdCategory(
      pswdCategoryNo: map['pswd_category_no'] as int?,
      categoryName: map['category_name'] as String,
    );
  }
}