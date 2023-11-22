import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:penny/screens/home_page.dart'; // Replace with your HomePage path
import 'package:penny/screens/signup_page.dart'; // Replace with your SignUpPage path

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = ''; // To display error messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/main_page.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                      Text(
                        'Penny',
                        style: GoogleFonts.phudu(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 60),
                      Text(
                        'Login',
                        style: GoogleFonts.phudu(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildEmailField(),
                      SizedBox(height: 20),
                      _buildPasswordField(),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _attemptLogin(context);
                          }
                        },
                        child: Text('Log In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(primary: Colors.black, onPrimary: Colors.white, minimumSize: Size.fromHeight(60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                            },
                            child: Text('Sign Up', style: TextStyle(color: Colors.amber)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Future<void> _attemptLogin(BuildContext context) async {
    var url = Uri.parse('http://127.0.0.1:8000/accounts/login/');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'email': _emailController.text, 'password': _passwordController.text}),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      String errorMessage = 'Login failed';
      if (response.statusCode == 401) {
        errorMessage = 'Email and password do not match';
      } else if (response.statusCode == 404) {
        errorMessage = 'User does not exist';
      }
      setState(() {
        _errorMessage = errorMessage;
      });
    }
  }
}
