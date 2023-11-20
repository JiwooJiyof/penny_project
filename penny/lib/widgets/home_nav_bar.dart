// home_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:penny/screens/user_profile.dart'; 
import 'package:penny/widgets/shopping_list.dart'; 

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
              position: RelativeRect.fromLTRB(0.0, AppBar().preferredSize.height, 0.0, 0.0),
              items: [
                PopupMenuItem<String>(
                  child: Text('View Profile'),
                  value: 'profile',
                ),
                PopupMenuItem<String>(
                  child: Text('Settings'),
                  value: 'settings',
                ),
                PopupMenuItem<String>(
                  child: Text('Help & Support'),
                  value: 'help',
                ),
                PopupMenuItem<String>(
                  child: Text('Log Out'),
                  value: 'logout',
                ),
              ],
            ).then((value) {
              if (value != null) {
                switch (value) {
                  case 'profile':
                    // Open the HelloWorldDialog when 'View Profile' is selected
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => HelloWorldDialog(),
                    );
                    break;
                  case 'settings':
                    // Handle settings action
                    break;
                  case 'help':
                    // Handle help action
                    break;
                  case 'logout':
                    // Handle logout action
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
