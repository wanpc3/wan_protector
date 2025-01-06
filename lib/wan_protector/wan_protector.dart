import 'package:flutter/material.dart';
import '../custom_btn/fab.dart';
import '../strings/strings.dart';
import '../status_bar/status_bar.dart';

//Import dart files
import 'vault.dart';
import 'categories.dart';
import 'deleted_pswd.dart';
import '../auth/login_user.dart';

class WanProtector extends StatefulWidget {
  const WanProtector({
    super.key
  });

  @override
  State<WanProtector> createState() => _WanProtectorState();
}

class _WanProtectorState extends State<WanProtector> {
  int _selectedIndex = 0;
  
  //Pages for navigation
  final List<Widget> _pages = [
    const Vault(),
    const Categories(),
    const DeletedPswd(),
    const LoginUser(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    //Set icons to white (Battery percentage, wifi, time & date, and other icons)
    setStatusBarStyle();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WanProtector',
          style: TextStyle(color: Colors.white), //Set title color to white
        ),
        backgroundColor: Color.fromARGB(255, 6, 84, 101),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      //Navigation Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 6, 84, 101),
              ),
              child: Text('WanProtector',
              style: TextStyle(color: Colors.white, fontSize: 20),),
            ),

            //Vault Page
            ListTile(
              title: const Text(Strings.vault_title),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              }
            ),

            //Categories Page
            ListTile(
              title: const Text(Strings.categories_title),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),

            //Deleted Passwords Page
            ListTile(
              title: const Text(Strings.deleted_pswd_title),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),

            //Login page
            ListTile(
              title: const Text('Login page sample'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              }
            ),
          ],
        ),
      ),

      //FAB that changes based on selected page
      floatingActionButton: _getFabAction(),
    );
  }

  //Returns FAB widget based on the selected index
  Widget _getFabAction() {
    switch (_selectedIndex) {
      
      case 0: //Vault Page
        return FloatingActionButton(
          onPressed: () {
            print('FAB Pressed on Vault');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEntryForm()),
            );
          },
          tooltip: 'Add Vault Entry',
          child: const Icon(Icons.add),
        );
      
      case 1: //Categories Page
        return FloatingActionButton(
          onPressed: () {
            print('FAB Pressed on Categories');
          },
          tooltip: 'Add Category',
          child: const Icon(Icons.category),
        );

      case 2: //Deleted Passwords Page
        return FloatingActionButton(
          onPressed: () {
            print('FAB Pressed on Deleted Passwords');
          },
          tooltip: 'Restore Password',
          child: const Icon(Icons.restore),
        );
      default:
        return Container(); //No FAB for other pages if necessary
    }
  }
}