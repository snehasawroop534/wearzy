class ProfileModel {
  int? userId;
  String? email;
  String? name;

  ProfileModel(
      this.userId,
      this.email,
      this.name,
      );

  static ProfileModel jsonToModel(Map<String, dynamic> json) {
    return ProfileModel(
      json["profile"]["userId"],
      json["profile"]["email"],
      json["profile"]["name"],
    );
  }
}
