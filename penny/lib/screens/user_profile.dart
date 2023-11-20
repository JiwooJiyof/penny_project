// hello_world_dialog.dart

import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String address = "27 King's College Cir, Toronto, ON M5S 1A1"; // Default address

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Dialog width is 80% of screen width
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(), // Close the dialog
              ),
            ),
            CircleAvatar(
              radius: 40, // Size of Avatar
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Bob Smith',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                // Implement change name functionality
              },
              child: Text('Change name'),
            ),
            SizedBox(height: 10),
            Text(
              'bob.smith@gmail.com',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                // Implement change email functionality
              },
              child: Text('Change email'),
            ),
            SizedBox(height: 10),
            Text(
              address,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                // Implement change address functionality
              },
              child: Text('Change address'),
            ),
            SizedBox(height: 20),
            Text(
              '••••••••',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                // Implement change password functionality
              },
              child: Text('Change password'),
            ),
          ],
        ),
      ),
    );
  }
}
