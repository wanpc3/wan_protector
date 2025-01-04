import 'package:flutter/material.dart';

/*
  Create Floating Action Button
*/

class Fab extends StatelessWidget {
  final VoidCallback onPressed;

  const Fab({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.yellow,
        child: Container(height: 50.0),
      ),
    );
  }
}