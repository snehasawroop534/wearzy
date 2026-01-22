class GetCartModel {
  int? cartId;
  int? userId;
  int? productId;
  Product? product;

  GetCartModel(this.cartId, this.userId, this.productId, this.product);

  static GetCartModel jsonToModel(Map<String, dynamic> json) {
    return GetCartModel(
      json["cartId"],
      json["userId"],
      json["productId"],
      json["product"] != null ? Product.jsonToModel(json["product"]) : null,
    );
  }
}

class Product {
  String? title;
  String? brand;
  String? image;
  String? mrp;
  String? discountedPrice;
  String? description;

  Product(
      {this.title,
        this.brand,
        this.image,
        this.mrp,
        this.discountedPrice,
        this.description});

  static Product jsonToModel(Map<String, dynamic> json) {
    return Product(
      title: json["title"],
      brand: json["brand"],
      image: json["image"] ?? "",
      mrp: json["mrp"].toString(),
      discountedPrice: json["discountedPrice"].toString(),
      description: json["description"],
    );
  }
}
