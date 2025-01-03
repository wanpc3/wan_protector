import 'package:flutter/material.dart';
import 'package:wan_protector/auth/custom_checkbox.dart';
import 'package:wan_protector/auth/verify_user.dart';
import 'package:wan_protector/smtp/send_email.dart';

//Show text
import '../strings/strings.dart';

//Firebase connection
import 'package:firebase_auth/firebase_auth.dart';

//Database connection
import '../database/wp_database_helper.dart';
import '../database/table_models/wp_user.dart';
import '../database/table_models/master_pswd.dart';

//Password Encryption
import '../encryption/encryption_helper.dart';

//Custom button
import '../custom_btn/login_register_btn.dart';

class RegisterUser extends StatefulWidget{
    const RegisterUser({super.key});

    @override
    RegisterUserState createState() => RegisterUserState();
}

class RegisterUserState extends State<RegisterUser> {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _master_passwordController = TextEditingController();
    final TextEditingController _confirm_master_passwordController = TextEditingController();
    
    //Firebase Auth instance
    //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    //Password visibility:
    bool _isPasswordVisible1 = false;
    bool _isPasswordVisible2 = false;

    //Terms of Service agreement:
    bool _isAgreedToTOS = false;

    //Call database
    final WPDatabaseHelper _wpDatabaseHelper = WPDatabaseHelper.instance;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('User Registration Form'),
        ),
        body: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Form(
           key: _formKey,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               //Email Input Row
               TextFormField(
                 controller: _emailController,
                 decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(),
                  ),
                  //Email Validation
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
                  controller: _master_passwordController,
                  decoration: InputDecoration(
                    labelText: 'Master Password',
                    hintText: 'Create your Master Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible1 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible1 = !_isPasswordVisible1;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible1,
                  validator: (value) {
                    //Form Validation
                    if (value == null || value.isEmpty) {
                      return 'Please create your Master Password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                  },
                ),

                //Confirm Master Password Input Row
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirm_master_passwordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Master Password',
                    hintText: 'Confirm your Master Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible2 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                        _isPasswordVisible2 = !_isPasswordVisible2;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible2, //True
                validator: (value) {
                  //Form Validation
                  if (value == null || value.isEmpty) {
                    return 'Please Confirm your Master Password';
                  }
                  if (value != _master_passwordController.text) {
                    return 'Master Password does not match';
                  }
                },
              ),

              //Remind user to always remember master password:
              const SizedBox(height: 16),
              Text(
                Strings.remember_master_pswd,
                style: TextStyle(color: Colors.red),
              ),

              //Terms of Service agreement:
              const SizedBox(height: 16),
              Row(
                children: [
                  CustomCheckbox(
                    value: _isAgreedToTOS,
                    onChanged: (value) {
                      setState(() {
                        _isAgreedToTOS = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Strings.agree_tos,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),

              //Submit button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 45.0,
                  child: ElevatedButton(
                    style: registerButtonStyle,
                    onPressed: () async {

                    //Validation order:
                    //Step 1:
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    //Step 2:
                    if (!_isAgreedToTOS) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(Strings.agree_tos_warn)),
                      );
                      return;
                    }
                    
                    //Step 3:
                    //Encrypt the master password
                    String encryptedPassword = EncryptionHelper.encryptText(_master_passwordController.text);

                      try {
                        //Register user in Firebase
                        //UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
                        //  email: _emailController.text,
                        //  password: _master_passwordController.text,
                        //);

                        //Insert user into the database
                        WPUser user = WPUser(email: _emailController.text);
                        int userId = await _wpDatabaseHelper.insertUser(user);

                        if (userId != -1) {
                          MasterPswd masterPassword = MasterPswd(
                            masterPswdText: encryptedPassword,
                            userNo: userId,
                          );
                          await _wpDatabaseHelper.insertMasterPassword(masterPassword);

                          //Send email verification
                          //await userCredential.user?.sendEmailVerification();
                          sendEmail(_emailController.text);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registration Successful')),
                          );

                          //Navigate to the next page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerifyUser(),
                            ),
                          );
                        } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error during registration')),
                            );
                          }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed: ${e.toString()}')),
                        );
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