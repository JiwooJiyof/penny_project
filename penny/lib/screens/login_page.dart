import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/home_page.dart'; // Replace with the correct path to your HomePage
import 'package:penny/screens/signup_page.dart'; // Replace with the correct path to your SignUpPage

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/main_page.png', // Using the same background as the HomePage
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
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          }
                        },
                        child: Text('Log In',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Button color
                          onPrimary: Colors.white, // Text color
                          minimumSize: Size.fromHeight(60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Button corner radius
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.amber,
                              ),
                            ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: _emailController,
        cursorColor: Colors.amber, // cursor color to amber
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black), // black label style
          focusedBorder: OutlineInputBorder(
            // amber focused border
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.amber),
          ),
          enabledBorder: OutlineInputBorder(
            // style when TextField is enabled
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.black),
          ),
          labelText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          // Add more specific validation for email if needed
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: _passwordController,
        cursorColor: Colors.amber, // cursor color to amber
        obscureText: true,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black), // black label style
          focusedBorder: OutlineInputBorder(
            // amber focused border
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.amber),
          ),
          enabledBorder: OutlineInputBorder(
            // style when TextField is enabled
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.black),
          ),
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }
}
