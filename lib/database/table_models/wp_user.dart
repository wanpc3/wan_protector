class WPUser {
  final int? userNo;
  final String email;
  final String username;

  WPUser({
    this.userNo,
    required this.email,
    required this.username
  });

  Map<String, dynamic> toMap() {
    return {
      'userNo': userNo,
      'email': email,
      'username': username
    };
  }

  factory WPUser.fromMap(Map<String, dynamic> map) {
    return WPUser(
      userNo: map['userNo'] as int?,
      email: map['email'] as String,
      username: map['username'] as String,
    );
  }
}