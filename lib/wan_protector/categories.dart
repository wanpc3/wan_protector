import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.home),
            title: Text('Category ${index + 1}'),
            onTap: () {
              print('Category ${index + 1} tapped');
            },
          );
        }
      ),
    );
  }
}