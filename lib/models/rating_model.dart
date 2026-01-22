class RatingModel {
  int? id;
  int userId;
  int orderId;
  int productId;
  int rating;
  String? review;
  String? createdAt;

  RatingModel({
    this.id,
    required this.userId,
    required this.orderId,
    required this.productId,
    required this.rating,
    this.review,
    this.createdAt,
  });

  // 🔹 From API (GET)
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      userId: json['user_id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      rating: json['rating'],
      review: json['review'],
      createdAt: json['created_at'],
    );
  }

  // 🔹 To API (POST)
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "orderId": orderId,
      "productId": productId,
      "rating": rating,
      "review": review,
    };
  }
}
