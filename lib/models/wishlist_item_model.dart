class WishlistItem {
  // Common IDs
  final int id; // wishlist id
  final int productId;
  final int? userId;

  // Product Details (nullable because ADD response me nahi aata)
  final String? title;
  final String? brand;
  final String? mrp;
  final String? discountedPrice;
  final String? description;
  final String? image;

  WishlistItem({
    required this.id,
    required this.productId,
    this.userId,
    this.title,
    this.brand,
    this.mrp,
    this.discountedPrice,
    this.description,
    this.image,
  });

  // ---------------------------
  // 🔵 FROM ADD WISHLIST API
  // ---------------------------
  factory WishlistItem.fromAddJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json["wishlistId"],
      productId: json["productId"] is String
          ? int.parse(json["productId"])
          : json["productId"],
      userId: json["userId"] is String
          ? int.parse(json["userId"])
          : json["userId"],
    );
  }

  // ---------------------------
  // 🔵 FROM GET WISHLIST API
  // ---------------------------
  factory WishlistItem.fromGetJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json["id"],
      productId: json["productId"],
      title: json["title"],
      brand: json["brand"],
      mrp: json["mrp"].toString(),
      discountedPrice: json["discountedPrice"].toString(),
      description: json["description"],
      image: json["image"],
    );
  }
}
