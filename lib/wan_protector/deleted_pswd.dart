import 'package:flutter/material.dart';

class DeletedPswd extends StatelessWidget {
  const DeletedPswd({
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
            title: Text('Deleted Password ${index + 1}'),
            onTap: () {
              print('Deleted Password ${index + 1} tapped');
            },
          );
        }
      ),
    );
  }
}