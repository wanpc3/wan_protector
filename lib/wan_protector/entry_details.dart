import 'package:flutter/material.dart';
import 'package:wan_protector/database/table_models/acc_entry.dart';
import 'package:wan_protector/database/table_models/user_pswd.dart';
import 'package:wan_protector/custom_btn/login_register_btn.dart';
import 'package:wan_protector/database/wp_database_helper.dart';
import 'package:wan_protector/strings/strings.dart';
import 'vault.dart';

class EntryDetails extends StatefulWidget {
  final AccEntry entry;
  final UserPswd pswd;

  EntryDetails({
    required this.entry,
    required this.pswd,
  });

  @override
  _EntryDetailsState createState() => _EntryDetailsState();
}

class _EntryDetailsState extends State<EntryDetails> {

  //Create global key
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _title;
  late TextEditingController _username;
  late TextEditingController _password;
  late TextEditingController _acc_url;
  late TextEditingController _notes;

  //Password length notifier
  final ValueNotifier<int> _passwordLength = ValueNotifier<int>(0);

  //Password visibility:
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with entry data
    _title = TextEditingController(text: widget.entry.accTitle);
    _username = TextEditingController(text: widget.entry.accUsername);
    _password = TextEditingController(text: widget.pswd.userPswdText);
    _acc_url = TextEditingController(text: widget.entry.accUrl);
    _notes = TextEditingController(text: widget.entry.addNotes);

    // Set initial password length
    _passwordLength.value = _password.text.length;
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    _title.dispose();
    _username.dispose();
    _password.dispose();
    _acc_url.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _saveChanges() async {
  if (_formKey.currentState!.validate()) {
    // Prepare updated data
    AccEntry updatedEntry = AccEntry(
      entryNo: widget.entry.entryNo, // Ensure you're updating the correct entry
      accTitle: _title.text,
      accUsername: _username.text,
      accUrl: _acc_url.text,
      addNotes: _notes.text,
    );

    UserPswd updatedPswd = UserPswd(
      userPswdText: _password.text,
      entryNoRef: widget.entry.entryNo!, // Foreign key reference
    );

    try {
      // Perform both updates
      int entryResult = await WPDatabaseHelper.instance.updateAccEntry(updatedEntry);
      int pswdResult = await WPDatabaseHelper.instance.updateUserPswd(updatedPswd);

      if (entryResult > 0 && pswdResult > 0) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All details updated successfully')),
        );

        // Navigate back with success state
        Navigator.pop(context, true); // true indicates changes were saved
      } else {
        // Handle partial success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update all details')),
        );
      }
    } catch (e) {
      // Handle errors
      print('Error saving changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while saving changes')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.edit_ent, // Appbar title
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Color.fromARGB(255, 6, 84, 101),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              //A little gap
              const SizedBox(height: 16),

              //Title
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Title cannot be empty';
                  return null;
                }
              ),

              const SizedBox(height: 16),

              // Username
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Title cannot be empty';
                  return null;
                }
              ),

              const SizedBox(height: 16),
              // Password 
              TextFormField(
                controller: _password,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    }
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Password cannot be empty';
                  return null;
                },
                onChanged: (value) {
                  //Update the password length (Real time)
                  _passwordLength.value = value.length;
                }
              ),

              const SizedBox(height: 8),
              //Password length display
              ValueListenableBuilder(
                valueListenable: _passwordLength,
                builder: (BuildContext context, int length, _) {
                  return Text(
                    'Password length: $length characters',
                    style: const TextStyle(color: Colors.black),
                  );
                },
              ),

              const SizedBox(height: 16),
              // URL
              TextFormField(
                controller: _acc_url,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              //Notes
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),

              const SizedBox(height: 16),
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 45.0,
                child: ElevatedButton(
                  style: saveChangesBtnStyle,
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}