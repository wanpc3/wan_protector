import '../../encryption/encryption_helper.dart';

class MasterPswd {
  final int? masterPswdNo;
  final String masterPswdText;
  final int userNo;

  MasterPswd({
    this.masterPswdNo,
    required this.masterPswdText,
    required this.userNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'master_pswd_no': masterPswdNo,
      'master_pswd_text': EncryptionHelper.encryptText(masterPswdText), //Encrypt before saving
      'user_no': userNo,
    };
  }

  factory MasterPswd.fromMap(Map<String, dynamic> map) {
    return MasterPswd(
      masterPswdNo: map['master_pswd_no'] as int?,
      masterPswdText: EncryptionHelper.decryptText(map['master_pswd_text'] as String), //Decrypt when reading
      userNo: map['userNo'] as int,
    );
  }
}