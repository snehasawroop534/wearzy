import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_services/profile_api.dart';
import '../models/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel? profile;
  bool isLoading = false;
  bool isUpdating = false; // <-- UPDATE LOADER

  ProfileProvider() {
    loadProfileFromLocal();
    fetchProfile();
  }

  // ---------------------------------------------
  // LOAD FROM SHARED PREF
  // ---------------------------------------------
  Future<void> loadProfileFromLocal() async {
    final pref = await SharedPreferences.getInstance();

    int? userId = pref.getInt("profile_userId");
    String? email = pref.getString("profile_email");
    String? name = pref.getString("profile_name");

    if (email != null && name != null) {
      profile = ProfileModel(userId, email, name);
      notifyListeners();
    }
  }

  // ---------------------------------------------
  // SAVE TO SHARED PREF
  // ---------------------------------------------
  Future<void> saveProfileToLocal(ProfileModel p) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt("profile_userId", p.userId ?? 0);
    await pref.setString("profile_email", p.email ?? "");
    await pref.setString("profile_name", p.name ?? "");
  }

  // ---------------------------------------------
  // FETCH PROFILE FROM API
  // ---------------------------------------------
  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    var res = await ProfileApi.userProfile();

    if (res != null) {
      profile = ProfileModel.jsonToModel(res);
      await saveProfileToLocal(profile!);
    }

    isLoading = false;
    notifyListeners();
  }

  // ---------------------------------------------
  // UPDATE PROFILE API  ✔✔ (ADDED)
  // ---------------------------------------------
  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    isUpdating = true;
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    int? userId = pref.getInt("profile_userId");

    if (userId == null) {
      isUpdating = false;
      notifyListeners();
      return false;
    }

    // API CALL
    final response = await ProfileApi.updateProfileApi(
      name: name,
      email: email,
      userId: userId,
    );

    if (response) {
      // UPDATE local model
      profile = ProfileModel(userId, email, name);

      // UPDATE shared pref
      await saveProfileToLocal(profile!);

      isUpdating = false;
      notifyListeners();
      return true;
    } else {
      isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  // ---------------------------------------------
  // LOGOUT पर CLEAR PROFILE
  // ---------------------------------------------
  Future<void> clearProfile() async {
    final pref = await SharedPreferences.getInstance();

    await pref.remove("profile_userId");
    await pref.remove("profile_email");
    await pref.remove("profile_name");

    profile = null;
    notifyListeners();
  }
}
