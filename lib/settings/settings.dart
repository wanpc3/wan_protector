import 'package:flutter/material.dart';
import '../strings/strings.dart';
import 'app_theme.dart';

class Settings extends StatefulWidget{
  const Settings({
    super.key
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('App Theme'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppTheme()),
              );
            }
          ),
        ],
      ),
    );
  }
}