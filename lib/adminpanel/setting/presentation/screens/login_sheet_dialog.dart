import 'package:family_tree/adminpanel/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LoginChoiceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Login As', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Temp User'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Admin'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
