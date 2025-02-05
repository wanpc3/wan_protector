//Import mailer package
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

//Generate the verification code
import 'verification_code.dart';

//To get environment value
//import 'package:flutter_dotenv/flutter_dotenv.dart';

//To send email containing 6-digit verification code.
void sendEmail(String userEmail) async {
  // String username = dotenv.env['EMAIL_USERNAME']!;
  // String password = dotenv.env['EMAIL_PASSWORD']!;
  String username = 'idrissilhan@gmail.com';
  String password = 'kjojoimwakjgzkud';

  final smtpServer = gmail(username, password);

  //Generate the verification code
  String verification_code = generateVerificationCode();

  //Save the verification code
  await saveVerificationCode(verification_code);

  //Create the message.
  // final message = Message()
  // ..from = Address(username, 'ILHAN IDRISS')
  // ..recipients.add(userEmail)
  // ..subject = 'WanProtector verification code'
  // ..html = """
  // <p>Thank you for registering with the WanProtector password manager.</p>
  // <p>Your verification code is <b>$verification_code</b></p>
  // <p>Please use this code to complete your registration.</p>
  // \n\n
  // <p>ILHAN IDRISS</p>
  // <p>(WanProtector developer)</p>
  // """;
  final message = Message()
  ..from = Address(username, 'ILHAN IDRISS')
  ..recipients.add(userEmail)
  ..subject = 'WanProtector newsletter'
  ..html = """
    <p>Welcome to WanProtector Password Manager!</p>
    <p>You have subscribed to WanProtector newsletter.</p>
  """;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email send: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Email cannot send. Error: ${e.toString()}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  } catch (e) {
    print('Unexpected error: ${e.toString()}');
  }
}