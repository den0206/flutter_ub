class FBUser {
  FBUser(this.id, this.fullname, this.email, this.phone);

  final String id;
  final String fullname;
  final String email;
  final int phone;

  Map<String, dynamic> toMap() {
    return {
      UserKey.id: id,
      UserKey.email: email,
      UserKey.fullname: fullname,
      UserKey.phone: phone,
    };
  }
}

class UserKey {
  static final id = "id";
  static final fullname = "fullname";
  static final email = "email";
  static final phone = "phone";
}
