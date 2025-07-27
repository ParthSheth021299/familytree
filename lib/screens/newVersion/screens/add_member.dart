import 'package:family_tree/screens/newVersion/demo.dart';
import 'package:flutter/material.dart';

class AddMember extends StatelessWidget {
  const AddMember({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              RootMember().addTransaction();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
