import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = 'Bob Smith';
  String email = 'bob.smith@gmail.com';
  String address = "27 King's College Cir, Toronto, ON M5S";
  String password = '••••••••';

  // Validator for password complexity
  bool isPasswordComplex(String password) {
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  void _changeName(BuildContext context) {
    TextEditingController _nameController = TextEditingController(text: name);
    _showDialog(
      context,
      'Change name',
      _nameController,
      (value) => setState(() => name = value),
    );
  }

  void _changeEmail(BuildContext context) {
    TextEditingController _emailController = TextEditingController(text: email);
    _showDialog(
      context,
      'Change email',
      _emailController,
      (value) => setState(() => email = value),
    );
  }

  void _changeAddress(BuildContext context) {
    TextEditingController _addressController =
        TextEditingController(text: address);
    _showDialog(
      context,
      'Change address',
      _addressController,
      (value) => setState(() => address = value),
    );
  }

  void _changePassword(BuildContext context) {
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'New password',
                ),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String newPassword = _passwordController.text;
                String confirmPassword = _confirmPasswordController.text;
                List<String> errors = [];

                if (newPassword.isEmpty || confirmPassword.isEmpty) {
                  errors.add('Fields cannot be empty.');
                }
                if (newPassword != confirmPassword) {
                  errors.add('Passwords do not match.');
                }
                if (newPassword.length < 8) {
                  errors.add('Password must be at least 8 characters.');
                }
                if (!RegExp(r'(?=.*[A-Z])').hasMatch(newPassword)) {
                  errors.add('Password must include an uppercase letter.');
                }
                if (!RegExp(r'(?=.*[a-z])').hasMatch(newPassword)) {
                  errors.add('Password must include a lowercase letter.');
                }
                if (!RegExp(r'(?=.*\d)').hasMatch(newPassword)) {
                  errors.add('Password must include a number.');
                }
                if (!RegExp(r'(?=.*[@$!%*#?&])').hasMatch(newPassword)) {
                  errors.add('Password must include a special character.');
                }

                if (errors.isNotEmpty) {
                  _showErrorDialog(context, errors.join('\n'));
                } else {
                  setState(() {
                    password = newPassword;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Generic dialog builder
  void _showDialog(BuildContext context, String title,
      TextEditingController controller, Function(String) onSave) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $title',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (controller.text.isEmpty) {
                  _showErrorDialog(context, '$title cannot be empty');
                } else {
                  onSave(controller.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns children to the start (left)
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Row(
              // Use Row to place the avatar and name text side by side
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // avatar icon ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                // SizedBox(width: 20), // Spacing between avatar and text
                // name ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                Expanded(
                  // Expanded to handle overflow of text
                  child: Text(
                    name,
                    style: GoogleFonts.phudu(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.amber),
                  onPressed: () => _changeName(context),
                ),
              ],
            ),
            SizedBox(height: 30),
            // email ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            _buildEditableField(Icon(Icons.email_outlined), 'Email', email,
                () => _changeEmail(context)),
            SizedBox(height: 20),
            // address ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            _buildEditableField(Icon(Icons.pin_drop_outlined), 'Address',
                address, () => _changeAddress(context)),
            SizedBox(height: 20),
            // password ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            _buildEditableField(Icon(Icons.lock_outline), 'Password', password,
                () => _changePassword(context)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
      Icon icon, String label, String value, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 10),
        icon,
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(value, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit_outlined, color: Colors.amber),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
