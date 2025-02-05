import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wan_protector/custom_btn/login_register_btn.dart';
import 'package:wan_protector/database/wp_database_helper.dart';
import 'package:wan_protector/encryption/encryption_helper.dart';
import '../strings/strings.dart';

//Page to access WanProtector password manager
import '../wan_protector/wan_protector.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  
  //Variable delarations
  final master_pswd = TextEditingController();
  bool isVisible = false;
  bool isLoginTrue = false;
  bool _isLoading = false;

  //Call database
  final WPDatabaseHelper _wpDatabaseHelper = WPDatabaseHelper.instance;
  final formKey = GlobalKey<FormState>();

  // Create an instance of FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  //Call this function once the submit button is pressed
  login() async {
    
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      isLoginTrue = false;
    });

    // Encrypt user input before checking with database
    String encryptedInputPassword = EncryptionHelper.encryptText(master_pswd.text);

    bool isLoginValid = await _wpDatabaseHelper.login(encryptedInputPassword);

    if (isLoginValid) {

      // Store the login state securely
      await _secureStorage.write(key: 'isLoggedIn', value: 'true');

      if (!mounted) return;
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WanProtector())
      );
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.login_title,
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Color.fromARGB(255, 6, 84, 101),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [

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
                  onPressed: _isLoading
                    ? null // Disable button while loading
                    : () {
                    if (formKey.currentState?.validate() ?? false) {
                      login();
                    }
                  },
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit'),
                ),
              ),

              // Show error message if login fails
              if (isLoginTrue)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Incorrect master password. Try again.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}