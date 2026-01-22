class SearchProductModel {
  int productId;
  String title;
  String brand;
  String mrp;
  String discountedPrice;
  String description;
  String image;

  SearchProductModel({
    required this.productId,
    required this.title,
    required this.brand,
    required this.mrp,
    required this.discountedPrice,
    required this.description,
    required this.image,
  });

  factory SearchProductModel.fromJson(Map<String, dynamic> json) {
    return SearchProductModel(
      productId: json["productId"],
      title: json["title"],
      brand: json["brand"],
      mrp: json["mrp"],
      discountedPrice: json["discountedPrice"],
      description: json["description"],
      image: json["image"],
    );
  }
}
