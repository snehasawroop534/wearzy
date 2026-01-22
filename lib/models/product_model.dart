class ProductModel {
  int? id;
  int? productId;
  int? categoryId; // ✅ NEW
  String? title;
  String? brand;
  String? mrp;
  String? discountedPrice;
  String? description;
  String? image;

  ProductModel(
      this.id,
      this.productId,
      this.categoryId, // ✅ NEW
      this.title,
      this.brand,
      this.mrp,
      this.discountedPrice,
      this.description,
      this.image,
      );

  static ProductModel jsonToModel(Map<String, dynamic> json) {
    return ProductModel(
      json["id"],
      json["productId"],
      json["category_id"], // ✅ MAP HERE
      json["title"],
      json["brand"],
      json["mrp"].toString(),
      json["discountedPrice"].toString(),
      json["description"],
      json["image"] ?? "",
    );
  }
}
