import 'package:flutter/material.dart';
import '../get_started/get_started_3.dart';

//Database connection
import '../database/wp_database_helper.dart';
import '../database/table_models/wp_user.dart';
import '../database/table_models/master_pswd.dart';

//Password Encryption
import '../encryption/encryption_helper.dart';

//Custom button
import '../custom_btn/login_register_btn.dart';

class RegisterScreen extends StatefulWidget{
    const RegisterScreen({super.key});

    @override
    RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    //final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _master_passwordController = TextEditingController();
    final TextEditingController _confirm_master_passwordController = TextEditingController();
    
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

                //Username Input Row
                /*
                const SizedBox(height: 16),
                    TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        border: OutlineInputBorder(),
                    ),
                    //Username Validation:
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                    }
                        return null;
                    },
                ),
                */

                //Master Password Input Row
                const SizedBox(height: 16),
                    TextFormField(
                    controller: _master_passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Master Password',
                        hintText: 'Create your Master Password',
                        border: OutlineInputBorder(),
                    ),

                    //To hide password's visibility:
                    obscureText: true,

                    //Master Password Validation:
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                            return 'Please create your Master Password';
                        }
                        if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                        }
                        return null;
                    },
                ),

                //Confirm Master Password Input Row
                const SizedBox(height: 16),
                    TextFormField(
                        controller: _confirm_master_passwordController,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Master Password',
                            hintText: 'Confirm your Master Password',
                            border: OutlineInputBorder(),
                        ),

                        //To hide password's visibility:
                        obscureText: true,
                        
                        //Confirm Master Password Validation:
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                                return 'Please Confirm your Master Password';
                            }
                            if (value != _master_passwordController.text) {
                                return 'Master Password does not match';
                            }
                            return null;
                        },
                    ),

                //Submit button
                const SizedBox(height: 16),
                SizedBox(
                    width: double.infinity,
                    height: 45.0,
                        child: ElevatedButton(
                          style: registerButtonStyle,
                          onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                              //Encrypt the master password
                              String encryptedPassword = EncryptionHelper.encryptText(_master_passwordController.text);

                              //Insert user into the database
                              WPUser user = WPUser(email: _emailController.text);
                              int userId = await _wpDatabaseHelper.insertUser(user);

                              if (userId != -1) {
                                MasterPswd masterPassword = MasterPswd(
                                  masterPswdText: encryptedPassword,
                                  userNo: userId,
                                );
                                await _wpDatabaseHelper.insertMasterPassword(masterPassword);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Registration Successful')),
                                );

                                //Navigate to the next page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GetStarted3(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error during registration')),
                                );
                              }
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