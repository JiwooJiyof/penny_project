import 'package:flutter/material.dart';

class HomeNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: const Icon(Icons.menu, color: Colors.black), // menu icon
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.shopping_cart,
              color: Colors.black), // shopping cart icon
        )
      ],
    );
  }
}
