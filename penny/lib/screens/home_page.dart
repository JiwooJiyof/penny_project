import 'package:flutter/material.dart';
import 'package:penny/widgets/categories.dart';
import 'package:penny/widgets/home_nav_bar.dart';
import 'package:penny/widgets/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/search_page.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeNavBar(), // Stationary AppBar
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/main_page.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Penny',
                          style: GoogleFonts.phudu(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 100),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          cursorColor: Colors.amber,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                // Navigate to the SearchPage when the search icon is clicked
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        SearchPage(
                                      inputText: _searchController.text,
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return child; // no animation, just return the child
                                    },
                                  ),
                                );
                              },
                              child: Icon(Icons.search, color: Colors.amber),
                            ),
                            hintText: 'Search for a product...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                      CategoriesWidget(),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Text(
                          "Today's Prices",
                          style: GoogleFonts.phudu(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ProductWidget(path: ""),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
