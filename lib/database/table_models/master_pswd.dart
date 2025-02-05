import '../../encryption/encryption_helper.dart';

class MasterPswd {
  final int? id;
  final String masterPswdText;

  MasterPswd({
    this.id,
    required this.masterPswdText,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'master_pswd_text': EncryptionHelper.encryptText(masterPswdText), //Encrypt before saving
    };
  }

  factory MasterPswd.fromMap(Map<String, dynamic> map) {
    return MasterPswd(
      id: map['id'] as int?,
      masterPswdText: EncryptionHelper.decryptText(map['master_pswd_text'] as String), //Decrypt when reading
    );
  }
}