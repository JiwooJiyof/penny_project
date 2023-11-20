import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          Center( // Center the SingleChildScrollView
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40), // Add padding to the sides
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Penny',
                      style: GoogleFonts.phudu(
                        fontSize: 100, // Larger font size for "Penny"
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 60), // Increased space between "Penny" and "Login"
                    Text(
                      'Login',
                      style: GoogleFonts.phudu(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement login logic
                      },
                      child: Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50), // sets the height of the button
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to password recovery
                      },
                      child: Text('Forgot Password?'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to sign up page
                          },
                          child: Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
