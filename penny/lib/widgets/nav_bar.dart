import 'package:flutter/material.dart';
import 'package:penny/screens/user_profile.dart';
import 'package:penny/widgets/shopping_list.dart';
import 'package:penny/screens/login_page.dart'; // Ensure this is the correct path

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _CircularButton(
          icon: Icons.menu,
          onPressed: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  0.0, AppBar().preferredSize.height, 0.0, 0.0),
              items: [
                PopupMenuItem<String>(
                  child: Text('View Profile'),
                  value: 'profile',
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // Call the UserProfile as a dialog
                        return UserProfile();
                      },
                    );
                    break;
                  case 'logout':
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                    break;
                }
              }
            });
          },
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _CircularButton(
            icon: Icons.shopping_cart_outlined,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => ShoppingCartDialog(),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CircularButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color hoverColor;
  final Color iconHoverColor;

  const _CircularButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.hoverColor = Colors.black, // Default hover color
    this.iconHoverColor = Colors.white, // Default icon hover color
  }) : super(key: key);

  @override
  State<_CircularButton> createState() => _CircularButtonState();
}

class _CircularButtonState extends State<_CircularButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _setHovering(true),
      onExit: (event) => _setHovering(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 48.0,
          height: 48.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovering ? widget.hoverColor : Colors.white,
            boxShadow: [
              BoxShadow(
                color: _isHovering
                    ? widget.hoverColor
                    : Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: _isHovering ? widget.iconHoverColor : Colors.black,
          ),
        ),
      ),
    );
  }

  void _setHovering(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }
}
