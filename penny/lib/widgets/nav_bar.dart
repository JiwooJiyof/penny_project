import 'package:flutter/material.dart';
import 'package:penny/screens/user_profile.dart';
import 'package:penny/widgets/shopping_list.dart';
import 'package:penny/screens/login_page.dart'; // Ensure this is the correct path

class HomeNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: Padding(
        padding: EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  0.0, AppBar().preferredSize.height, 0.0, 0.0),
              items: [
                PopupMenuItem<String>(
                  child: Text('View Profile'),
                  value: 'profile',
                ),
                // PopupMenuItem<String>(
                //   child: Text('Settings'),
                //   value: 'settings',
                // ),
                // PopupMenuItem<String>(
                //   child: Text('Help & Support'),
                //   value: 'help',
                // ),
                PopupMenuItem<String>(
                  child: Text('Log Out'),
                  value: 'logout',
                ),
              ],
            ).then((value) {
              if (value != null) {
                switch (value) {
                  case 'profile':
                    // Implement navigation to the user profile
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfile()),
                    );
                    break;
                  // case 'settings':
                  //   // Handle settings action
                  //   // Navigate to settings page (if exists)
                  //   break;
                  // case 'help':
                  //   // Handle help action
                  //   // Navigate to help & support page (if exists)
                  //   break;
                  case 'logout':
                    // Navigate to the login page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                    break;
                }
              }
            });
          },
          child: Icon(
            Icons.menu,
            color: Colors.black,
            size: 45.0,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => ShoppingCartDialog(),
              );
            },
            child: Icon(
              Icons.shopping_cart,
              color: Colors.black,
              size: 40.0,
            ),
          ),
        ),
      ],
    );
  }
}
