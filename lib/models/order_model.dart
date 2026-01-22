class OrderItem {
  final int productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "quantity": quantity,
      "price": price,
    };
  }
}




class PlaceOrderRequest {
  final int userId;
  final double totalAmount;
  final List<OrderItem> items;

  PlaceOrderRequest({
    required this.userId,
    required this.totalAmount,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "totalAmount": totalAmount,
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}

class PlaceOrderResponse {
  final String message;
  final int orderId;

  PlaceOrderResponse({
    required this.message,
    required this.orderId,
  });

  factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponse(
      message: json["message"],
      orderId: json["orderId"],
    );
  }
}


/// 🔥 GET MY ORDERS MODEL
class MyOrderModel {
  final int orderId;
  final int userId;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  /// 🔥 NEW
  final List<OrderProductItem> items;

  MyOrderModel({
    required this.orderId,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory MyOrderModel.fromJson(Map<String, dynamic> json) {
    return MyOrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      totalAmount: double.parse(json['totalAmount'].toString()),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),

      /// 🔥 ITEMS PARSE
      items: (json['items'] as List)
          .map((e) => OrderProductItem.fromJson(e))
          .toList(),
    );
  }
}


class OrderProductItem {
  final int productId;
  final String title;
  final String description;
  final String image;
  final int quantity;
  final double price;

  OrderProductItem({
    required this.productId,
    required this.title,
    required this.description,
    required this.image,
    required this.quantity,
    required this.price,
  });

  factory OrderProductItem.fromJson(Map<String, dynamic> json) {
    return OrderProductItem(
      productId: json['productId'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
    );
  }
}


