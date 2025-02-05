import 'package:flutter/material.dart';
import '../custom_btn/fab.dart';
import '../strings/strings.dart';
import '../status_bar/status_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Import dart files
import 'vault.dart';
import 'add_entry.dart';
import 'categories.dart';
import 'deleted_pswd.dart';
import '../settings/settings.dart';
import '../auth/login_user.dart';
import '../auth/login_status.dart';

// Import database
import '../database/wp_database_helper.dart';

class WanProtector extends StatefulWidget {
  const WanProtector({
    super.key
  });

  @override
  State<WanProtector> createState() => _WanProtectorState();
}

class _WanProtectorState extends State<WanProtector> {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  int _selectedIndex = 0;

  // Titles for the AppBar
  final List<String> _titles = [
    Strings.vault_title,
    Strings.categories_title,
    Strings.deleted_pswd_title,
    Strings.settings_title
  ];
  
  //Define ValueNotifier for auto-reloading Vault
  final ValueNotifier<int> _reloadNotifier = ValueNotifier<int>(0);

  //Pages for navigation
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Vault(reloadNotifier: _reloadNotifier),
      const Categories(),
      const DeletedPswd(),
      const Settings(),
    ];
    _checkLoginStatus();
  }

  // Call the checkLoginStatus function from the helper file
  _checkLoginStatus() {
    checkLoginStatus(context); // Use the function from the imported file
  }

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
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(color: Colors.white), //Set title color to white
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
              child: Text(
                'WanProtector',
                style: TextStyle(color: Colors.white, fontSize: 20),),
            ),

            //Vault Page
            ListTile(
              leading: const Icon(Icons.home, color: Colors.grey),
              title: const Text(Strings.vault_title),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              }
            ),

            //Categories Page
            ListTile(
              leading: const Icon(Icons.category, color: Colors.grey),
              title: const Text(Strings.categories_title),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),

            //Deleted Passwords Page
            ListTile(
              leading: const Icon(Icons.restore_from_trash, color: Colors.grey),
              title: const Text(Strings.deleted_pswd_title),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),

            //Settings page
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text(Strings.settings_title),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),

            //Logout page
            ListTile(
              leading: const Icon(Icons.logout_sharp, color: Colors.grey),
              title: const Text('Logout'),
              selected: _selectedIndex == 4,
              onTap: () {
                _logout();
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
              MaterialPageRoute(
                builder: (context) => AddEntryForm(
                  onEntryAdded: () {
                    _reloadNotifier.value++;
                  },
                ),
              ),
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

      case 3: //Settings Page
        return FloatingActionButton(
          onPressed: () {
            print('FAB Pressed on Settings');
          },
          tooltip: 'Settings',
          child: const Icon(Icons.settings),
        );
        
      default:
        return Container(); //No FAB for other pages if necessary
    }
  }

  void _logout() async {
    await _secureStorage.delete(key: 'isLoggedIn');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginUser())
    );
  }
}