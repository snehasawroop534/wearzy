import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../api_services/address_service.dart';

class AddressProvider with ChangeNotifier {
  List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;

  // Add a new address
  Future<bool> addAddress(AddressModel address) async {
    final addedAddress = await AddressService.addAddress(address);
    if (addedAddress != null) {
      _addresses.add(addedAddress);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchAddresses(int userId) async {
    final list = await AddressService.getAddresses(userId);
    _addresses = list;
    notifyListeners();
  }

  // ✏️ UPDATE ADDRESS
  Future<bool> updateAddress(int addressId, AddressModel updatedAddress) async {
    final success =
    await AddressService.updateAddress(addressId, updatedAddress);

    if (success) {
      final index =
      _addresses.indexWhere((a) => a.addressId == addressId);

      if (index != -1) {
        _addresses[index] = updatedAddress;
        notifyListeners();
      }
    }

    return success;
  }


// 🗑 DELETE ADDRESS
  Future<bool> deleteAddress(int addressId) async {
    final success = await AddressService.deleteAddress(addressId);

    if (success) {
      _addresses.removeWhere((a) => a.addressId == addressId);
      notifyListeners();
    }

    return success;
  }



  // Optional: fetch all addresses (if you have an API for that)
  void setAddresses(List<AddressModel> list) {
    _addresses = list;
    notifyListeners();
  }


}
