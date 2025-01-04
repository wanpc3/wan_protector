import 'package:flutter/material.dart';
import '../custom_btn/fab.dart';
import 'categories.dart';

class Vault extends StatefulWidget {
  const Vault({
    super.key
  });

  @override
  State<Vault> createState() => _VaultState();
}

class _VaultState extends State<Vault> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = 
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Vault',
      style: optionStyle,
    ),
    Text(
      'Index 1: All Categories',
      style: optionStyle,
    ),
    Text(
      'Index 2: Deleted Passwords',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WanProtector'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              }
            );
          },
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),

      //Navigation Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),

            ListTile(
              title: const Text('Vault'),
              selected: _selectedIndex == 0,
              onTap: () {
                //Update the state of the app
                _onItemTapped(0);
                //Then close the drawer
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: const Text('All Categories'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: const Text('Deleted Passwords'),
              selected: _selectedIndex == 2,
              onTap: () {
                //Update the state of the app
                _onItemTapped(2);
                //Then close the drawer
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
      //FAB is here
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Define action here (e.g., navigate to a new screen or open a dialog)
          print('FAB Pressed');
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}