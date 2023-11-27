import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = '';
  String username = '';
  String email = '';
  String address = '';
  String password = '*******';
  // ... Other fields remain unchanged

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
  try {
    final response = await http.get(Uri.parse('https://boolean-boos.onrender.com/accounts/info/'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      setState(() {
        name = data['name'];
        username = data['username'];
        email = data['email'];
        address = data['address'];
      });
    } else {
      // Print status code and body for more detailed error information
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Print the exception to understand network errors
    print('An error occurred: $e');
  } finally {
    // Code to run regardless of success or failure (optional)
    // e.g., hide loading indicator
  } }


  // Validator for password complexity
  bool isPasswordComplex(String password) {
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    if (value.length < 6 || value.length > 30) {
      return 'Username must be between 6 and 30 characters';
    }
    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
      return 'Username must start with a letter and only contain letters, numbers, and underscores';
    }
    return null;
  }

  void _changeName(BuildContext context) {
    TextEditingController _nameController = TextEditingController(text: name);
    _showDialog(
      context,
      'Change name',
      _nameController,
       (value) {
        updateUserInfo('name', value).then((_) {
          setState(() => name = value);
        }).catchError((error) {
          _showErrorDialog(context, 'Failed to update name.');
        });
      },
    );
  }

  void _changeUsername(BuildContext context) {
    TextEditingController _usernameController =
        TextEditingController(text: username);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change username'),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Enter new username',
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
                String? validationMessage = _validateUsername(_usernameController.text);
                if (validationMessage == null) {
                  updateUserInfo('username', _usernameController.text)
                    .then((_) {
                      setState(() {
                        username = _usernameController.text;
                      });
                      Navigator.of(context).pop();
                    })
                    .catchError((error) {
                      _showErrorDialog(context, 'Failed to update username.');
                    });
                } else {
                  _showErrorDialog(context, validationMessage);
                }
              },
            ),
          ]
        );
      },
    );
  }

  void _changeEmail(BuildContext context) {
  TextEditingController _emailController = TextEditingController(text: email);
  _showDialog(
    context,
    'Change email',
    _emailController,
    (value) {
      updateUserInfo('email', value).then((_) {
        setState(() => email = value);
      }).catchError((error) {
        _showErrorDialog(context, 'Failed to update email.');
      });
    },
  );
}


  void _changeAddress(BuildContext context) {
  TextEditingController _addressController = TextEditingController(text: address);
  _showDialog(
    context,
    'Change address',
    _addressController,
    (value) {
      updateUserInfo('address', value).then((_) {
        setState(() => address = value);
      }).catchError((error) {
        _showErrorDialog(context, 'Failed to update address.');
      });
    },
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
                  updateUserInfo('password', _passwordController.text)
                    .then((_) {
                      setState(() {
                        password = '*******';
                      });
                      Navigator.of(context).pop();
                    })
                    .catchError((error) {
                      _showErrorDialog(context, 'Failed to update password.');
                    });
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
            // username ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            _buildEditableField(Icon(Icons.person_outline), 'Username',
                username, () => _changeUsername(context)),
            // email ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            _buildEditableField(Icon(Icons.email_outlined), 'Email', email,
                () => _changeEmail(context)),
            // address ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            _buildEditableField(Icon(Icons.location_on_outlined), 'Address',
                address, () => _changeAddress(context)),
            // password ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            _buildEditableField(Icon(Icons.lock_outline), 'Password', password,
                () => _changePassword(context)),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
      Icon icon, String label, String value, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}


Future<void> updateUserInfo(String field, String value) async {
  try {
    final response = await http.put(
      Uri.parse('https://boolean-boos.onrender.com/accounts/update/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({field: value}), // Dynamically set the field and value
    );

    if (response.statusCode == 200) {
      // Handle success
      print('User info updated successfully.');
    } else {
      // Handle error
      print('Failed to update user info: ${response.body}');
    }
  } catch (e) {
    // Handle network error
    print('An error occurred: $e');
  }
}

