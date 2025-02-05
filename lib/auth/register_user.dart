import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wan_protector/auth/custom_checkbox.dart';
import 'package:wan_protector/auth/verify_user.dart';
import 'package:wan_protector/database/collect_wp_user.dart';
import 'package:wan_protector/get_started/get_started.dart';
import 'package:wan_protector/smtp/send_email.dart';
import '../auth/login_user.dart';

//Show text
import '../strings/strings.dart';

//Firebase connection
import 'package:firebase_core/firebase_core.dart';

//Database connection
import '../database/wp_database_helper.dart';
import '../database/table_models/newsletter_subscriber.dart';
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

    //Newsletter subscription
    bool _isSubsNewsLetter = false;
    bool _isChecked = false;

    //Call database
    final WPDatabaseHelper _wpDatabaseHelper = WPDatabaseHelper.instance;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.reg_form,
            style: TextStyle(color: Colors.white)
          ),
          backgroundColor: Color.fromARGB(255, 6, 84, 101),
          //iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Form(
           key: _formKey,
           child: ListView(
             children: [

               //Email Input Row
               /*
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
                */

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

              const SizedBox(height: 15),

              // Newsletter subscription:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckbox(
                    value: _isSubsNewsLetter,
                    onChanged: (value) {
                      setState(() {
                        _isSubsNewsLetter = value!;
                        _isChecked = value;
                      });
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(Strings.newsltr),
                        if (_isChecked) // Show only when checked
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(),
                              ),
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
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              
              //Terms of Service agreement: (This is highly necessary)
              //const SizedBox(height: 16),
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
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: Strings.agree,
                        style: const TextStyle(color: Colors.black),
                        children: [

                          //Terms of Service
                          TextSpan(
                            text: Strings.tos,
                            style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => GetStarted()),
                              // );
                            }
                          ),

                          //and
                          TextSpan(
                            text: ' and ',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),

                          //Privacy Policy
                          TextSpan(
                            text: Strings.privacy_policy,
                            style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => GetStarted()),
                              // );
                            }
                          ),

                          //Full stop
                          TextSpan(
                            text: '.',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
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

                        //Insert master password to db
                        MasterPswd masterPassword = MasterPswd(
                          masterPswdText: encryptedPassword,
                        );
                        await _wpDatabaseHelper.insertMasterPassword(masterPassword);

                        //If user want to receive newsletter from WanProtector:
                        if (_emailController.text.trim().isNotEmpty) {
                          //Get the email form data
                          final String email = _emailController.text.trim();
                          final bool isSubscribed = _isSubsNewsLetter;
                          final String newsletter = isSubscribed ? 'subscribed' : 'not_subscribed';

                          //Insert user into the database locally
                          NewsLetter_Subscriber newsSubscriber = NewsLetter_Subscriber(
                            email: email,
                            newsletter: newsletter,
                            created_at: Timestamp.now(),
                          );

                          // Save to Firestore
                          final collectWPUser = CollectWPUser();
                          await collectWPUser.addNewsLetter_Subscriber(newsSubscriber);

                          //  Tell user that they have subscribed to WanProtector's newsletter
                          sendEmail(_emailController.text);
                        }

                        //Navigate to the next page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginUser(),//VerifyUser(email: _emailController.text),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed: ${e.toString()}')),
                        );
                      }
                    },
                    child: const Text('Register'),
                    ),
                  ),

                  //Gap at the bottom
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
    }
}