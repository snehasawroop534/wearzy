class CartModel {
  int? cartId;
  int? userId;
  int? productId;
  String? size;
  int? quantity;
  String? price;

  // NEW FIELDS FROM API
  String? title;
  String? brand;
  String? image;
  String? mrp;
  String? discountedPrice;
  String? description;

  CartModel({
    this.cartId,
    this.userId,
    this.productId,
    this.size,
    this.quantity,
    this.price,
    this.title,
    this.brand,
    this.image,
    this.mrp,
    this.discountedPrice,
    this.description,
  });

  // FROM JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json["cartId"],
      userId: json["userId"],
      productId: json["productId"],
      size: json["size"],
      quantity: json["quantity"],
      price: json["price"],
      title: json["title"],
      brand: json["brand"],
      image: json["image"],
      mrp: json["mrp"],
      discountedPrice: json["discountedPrice"],
      description: json["description"],
    );
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      "cartId": cartId,
      "userId": userId,
      "productId": productId,
      "size": size,
      "quantity": quantity,
      "price": price,
      "title": title,
      "brand": brand,
      "image": image,
      "mrp": mrp,
      "discountedPrice": discountedPrice,
      "description": description,
    };
  }
}
