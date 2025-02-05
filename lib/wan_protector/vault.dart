import 'package:flutter/material.dart';
import 'package:wan_protector/database/wp_database_helper.dart';

//Import tables
import '../database/table_models/acc_entry.dart';
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

                          // Get information from database
                          final entryDetails = await WPDatabaseHelper.instance.fetchAccEntry(entry.entryNo!);
                          final pswdDetails = await WPDatabaseHelper.instance.fetchUserPswdByEntryNo(entry.entryNo!);

                          if (entryDetails != null && pswdDetails != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntryDetails(entry: entryDetails, pswd: pswdDetails),
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
