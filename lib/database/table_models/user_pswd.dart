class UserPswd {
  final String userPswdText;
  final int entryNoRef;

  UserPswd({
    required this.userPswdText,
    required this.entryNoRef,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_pswd_text': userPswdText,
      'entry_no_ref': entryNoRef,
    };
  }

  factory UserPswd.fromMap(Map<String, dynamic> map) {
    return UserPswd(
      userPswdText: map['user_pswd_text'],
      entryNoRef: map['entry_no_ref'],
    );
  }
}