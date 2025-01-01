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
      'masterPswdNo': masterPswdNo,
      'masterPswdText': EncryptionHelper.encryptText(masterPswdText), //Encrypt before saving
      'userNo': userNo,
    };
  }

  factory MasterPswd.fromMap(Map<String, dynamic> map) {
    return MasterPswd(
      masterPswdNo: map['masterPswdNo'] as int?,
      masterPswdText: EncryptionHelper.decryptText(map['masterPswdText'] as String), //Decrypt when reading
      userNo: map['userNo'] as int,
    );
  }
}