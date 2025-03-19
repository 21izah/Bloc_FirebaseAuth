class AppUser {
  final String uid;
  final String? email;
  final String name;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
  });

  // convert app user -> json

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
    };
  }

  // convert json to -> app user

  factory AppUser.fromJson(Map<String, dynamic> jsomUser) {
    return AppUser(
        uid: jsomUser["uid"], email: jsomUser["email"], name: jsomUser["name"]);
  }
}
