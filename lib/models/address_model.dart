class AddressModel {
  final int? addressId;
  final int userId;
  final String fullName;
  final String phone;
  final String pincode;
  final String state;
  final String city;
  final String houseNo;
  final String addressType;

  AddressModel({
    this.addressId,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.pincode,
    required this.state,
    required this.city,
    required this.houseNo,
    required this.addressType,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['id'], // ✅ FIX HERE
      userId: json['userId'],
      fullName: json['fullName'],
      phone: json['phone'],
      pincode: json['pincode'],
      state: json['state'],
      city: json['city'],
      houseNo: json['houseNo'],
      addressType: json['addressType'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "fullName": fullName,
      "phone": phone,
      "pincode": pincode,
      "state": state,
      "city": city,
      "houseNo": houseNo,
      "addressType": addressType,
    };
  }
}
