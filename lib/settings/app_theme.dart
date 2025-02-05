import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../strings/strings.dart';

class AppTheme extends StatefulWidget{
  
  const AppTheme({
    super.key
  });

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.app_theme_title,
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Color.fromARGB(255, 6, 84, 101),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            child: SwitchListTile(
              title: Text(isDarkMode ? "Dark Mode" : "Light Mode"),
              value: isDarkMode,
              onChanged: (value) {
                if (value) {
                  AdaptiveTheme.of(context).setDark();
                } else {
                  AdaptiveTheme.of(context).setLight();
                }
                setState(() {}); // Refresh the UI to reflect the new theme
              },
            ),
          ),
        ],
      ),
    );
  }
}