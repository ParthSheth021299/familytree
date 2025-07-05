import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        color: Colors.yellow.shade100,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Made with ❤️ for the Dahibanagar family",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: Text(
                "v1.0 • Updated: June 2025",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
