import 'package:flutter/material.dart';
import 'package:wan_protector/database/table_models/acc_entry.dart';
import 'vault.dart';

class EntryDetails extends StatelessWidget {
  final AccEntry entry;

  EntryDetails({
    required this.entry
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.accTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${entry.accUsername}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'URL: ${entry.accUrl ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Notes: ${entry.addNotes ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}