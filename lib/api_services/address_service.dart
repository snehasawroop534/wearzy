import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/address_model.dart';

class AddressService {
  static const String baseUrl = "https://wearzy.edugaondev.com";

  static Future<AddressModel?> addAddress(AddressModel address) async {
    try {
      print('Sending address: ${jsonEncode(address.toJson())}');
      final response = await http.post(
        Uri.parse('$baseUrl/api/address/add'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(address.toJson()),
      );
      print('Response code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return AddressModel(
          addressId: data['addressId'],
          userId: address.userId,          // local address object se
          fullName: address.fullName,
          phone: address.phone,
          pincode: address.pincode,
          state: address.state,
          city: address.city,
          houseNo: address.houseNo,
          addressType: address.addressType,
        );
      } else {
        print('Failed to add address: ${response.statusCode} | ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in addAddress API: $e');
      return null;
    }
  }


  static Future<List<AddressModel>> getAddresses(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/address?userId=$userId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List list = data['addresses'];

        return list
            .map((e) => AddressModel.fromJson(e))
            .toList();
      } else {
        print("Failed to fetch addresses: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching addresses: $e");
      return [];
    }
  }

  // 🔄 UPDATE ADDRESS
  static Future<bool> updateAddress(
      int addressId,
      AddressModel address,
      ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/address/$addressId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(address.toJson()),
      );

      print("Update address response: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to update address");
        return false;
      }
    } catch (e) {
      print("Error updating address: $e");
      return false;
    }
  }


// 🗑 DELETE ADDRESS
  static Future<bool> deleteAddress(int addressId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/address/$addressId'),
        headers: {"Content-Type": "application/json"},
      );

      print("Delete address response: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete address");
        return false;
      }
    } catch (e) {
      print("Error deleting address: $e");
      return false;
    }
  }


}
