import 'package:flutter/material.dart';
import 'package:wan_protector/custom_btn/login_register_btn.dart';
import 'package:wan_protector/database/wp_database_helper.dart';
import 'package:wan_protector/encryption/encryption_helper.dart';

//Import tables
import '../database/table_models/wp_user.dart';
import '../database/table_models/master_pswd.dart';
import '../wan_protector/vault.dart';

//Page to access WanProtector password manager
import '../wan_protector/wan_protector.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  
  //Variable delarations
  final email = TextEditingController();
  final master_pswd = TextEditingController();

  //Passwords visibility
  bool isVisible = false;

  //Here is our bool variable
  bool isLoginTrue = false;

  //Call database
  final WPDatabaseHelper _wpDatabaseHelper = WPDatabaseHelper.instance;

  //Call this function once the submit button is pressed
  login() async {
    WPUser user = WPUser(email: email.text);
    MasterPswd masterPswd = MasterPswd(masterPswdText: master_pswd.text, userNo: 1);

    bool isLoginValid = await _wpDatabaseHelper.login(user, masterPswd);

    if (isLoginValid) {
      if (!mounted)
        return;
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WanProtector())
      );
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Email input row:
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email',
                  border: OutlineInputBorder(),
                ),
                //Email validation
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              //Master Password Input Row
              const SizedBox(height: 16),
              TextFormField(
                controller: master_pswd,
                decoration: InputDecoration(
                  labelText: 'Master Password',
                  hintText: 'Enter master password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                  ),
                ),
                obscureText: !isVisible,
                validator: (value) {
                  //Master password validation
                  if (value == null || value.isEmpty) {
                    return 'Enter master password to access vault';
                  }
                  return null;
                }
              ),

              //Submit button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 45.0,
                child: ElevatedButton(
                  style: registerButtonStyle,
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      login();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}