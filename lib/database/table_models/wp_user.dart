class WPUser {
  final int? userNo;
  final String email;

  WPUser({
    this.userNo,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_no': userNo,
      'email': email,
    };
  }

  factory WPUser.fromMap(Map<String, dynamic> map) {
    return WPUser(
      userNo: map['user_no'] as int?,
      email: map['email'] as String,
    );
  }
}