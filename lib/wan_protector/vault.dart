import 'package:flutter/material.dart';
import 'package:wan_protector/custom_btn/login_register_btn.dart';
import 'package:wan_protector/database/wp_database_helper.dart';
import 'package:wan_protector/encryption/encryption_helper.dart';

//Import tables
import '../database/table_models/acc_entry.dart';
import '../database/table_models/user_pswd.dart';
import 'entry_details.dart';

class Vault extends StatelessWidget {
  final ValueNotifier<int> reloadNotifier;
  
  Vault({
    super.key,
    required this.reloadNotifier
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault'),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: reloadNotifier,
        builder: (context, _, __) {
          return FutureBuilder<List<AccEntry>>(
            future: _fetchAccountEntries(), // Fetch data from database
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center (child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No entries found.'));
              } else {
                final entries = snapshot.data!;

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.key_sharp,
                        color: Color.fromARGB(255, 255, 215, 0),
                      ),
                      title: Text(entry.accTitle),
                      subtitle: Text(entry.accUsername),
                      onTap: () async {
                        if (entry.entryNo != null) {
                          final entryDetails = await WPDatabaseHelper.instance.fetchAccEntry(entry.entryNo!); 
                        
                          if (entryDetails != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntryDetails(entry: entryDetails),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Entry not found!')),
                            );
                          }
                        }
                      },
                    );
                  },
                );
              }
            },
          );
        }
      ),
    );
  }

   //Method to fetch account entries from the database
  Future<List<AccEntry>> _fetchAccountEntries() async {
    final db = WPDatabaseHelper.instance;
    final data = await db.queryAll('acc_entry');
    return data.map((entryData) => AccEntry.fromMap(entryData)).toList();
  }
}

class AddEntryForm extends StatefulWidget {
  final VoidCallback? onEntryAdded;

  const AddEntryForm({
    super.key,
    this.onEntryAdded,
  });

  @override
  AddEntryFormState createState() => AddEntryFormState();
}

class AddEntryFormState extends State<AddEntryForm> {

  //Create global key
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _acc_url = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  //Password visibility:
  bool _isPasswordVisible = false;

  //Call database
  final WPDatabaseHelper _wpDatabaseHelper = WPDatabaseHelper.instance;

  @override build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Entry'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title input row
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter title',
                  border: OutlineInputBorder(),
                ),
                //Form validation
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                }
              ),

              const SizedBox(height: 16), //It's like the gap between textboxes
              //Username input row
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(
                  labelText: 'Username / Email',
                  hintText: 'Enter username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username / Email cannot be empty';
                  }
                  return null;
                }
              ),

              //Password input row
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
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
                obscureText: !_isPasswordVisible, //Hides password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              //URL input row
              TextFormField(
                controller: _acc_url,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'Enter URL',
                  border: OutlineInputBorder(),
                ),
                //No validation because it's optional
              ),

              const SizedBox(height: 16),
              //Notes input row
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Add some notes',
                  border: OutlineInputBorder(),
                ),
                //No validation because it's optional
              ),

              //Finally, add entry button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 45.0,
                child: ElevatedButton(
                  style: registerButtonStyle, //After this, create custom button for add entry
                  onPressed: () async {

                    //Validation order:
                    //Step 1: Make sure all row title, username/email, and passwords are inserted
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    //Step 2: Encrypt the password (This is very important):
                    String encryptedPassword = EncryptionHelper.encryptText(_password.text);

                    try {
                      //Step 3: Insert account entry into the database
                      AccEntry accEntry = AccEntry(
                        entryNo: null,
                        accTitle: _title.text,
                        accUsername: _username.text,
                        accUrl: _acc_url.text.isEmpty ? null : _acc_url.text,
                        addNotes: _notes.text.isEmpty ? null : _notes.text,
                      );

                      int entryId = await _wpDatabaseHelper.insertAccEntry(accEntry);

                      //Step 4: Insert encrypted password linked to the entry
                      if (entryId != -1) {
                        UserPswd userPswd = UserPswd(
                          userPswdText: encryptedPassword,
                          entryNoRef: entryId,
                        );

                        int pswdId = await _wpDatabaseHelper.insert('user_pswd', userPswd.toMap());
                        if (pswdId != -1) {
                          widget.onEntryAdded?.call();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Entry added successfully!')),
                          );

                          Navigator.pop(context);
                        } else {
                          throw Exception('Failed to insert user password.');
                        }
                      } else {
                        throw Exception('Failed to insert account entry.');
                      }
                    } catch (e) {
                      print('Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to insert account entry.')),
                      );
                    }
                  },
                  child: const Text('Add Entry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _username.dispose();
    _password.dispose();
    _acc_url.dispose();
    _notes.dispose();
    super.dispose();
  }
}