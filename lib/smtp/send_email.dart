//Import mailer package
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

//Generate the verification code
import 'verification_code.dart';

//To send email containing 6-digit verification code.
void sendEmail(String userEmail) async {
  String username = 'idrissilhan@gmail.com';
  String password = 'kjojoimwakjgzkud';

  final smtpServer = gmail(username, password);

  //Generate the verification code
  String verification_code = generateVerificationCode();

  //Create the message.
  final message = Message()
  ..from = Address(username, 'ILHAN IDRISS')
  ..recipients.add(userEmail)
  ..subject = 'WanProtector verification code'
  ..html = """
  <p>Thank you for registering with the WanProtector password manager.</p>
  <p>Your verification code is <b>$verification_code</b></p>
  <p>Please use this code to complete your registration.</p>
  \n\n
  <p>ILHAN IDRISS</p>
  <p>(WanProtector developer)</p>
  """;

  try {
    final sendReport = await send(message, smtpServer);
    print('Verification code sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Verification code not sent. Error: ${e.toString()}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  } catch (e) {
    print('Unexpected error: ${e.toString()}');
  }
}