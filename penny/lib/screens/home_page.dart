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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeNavBar(),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/main_page.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60), // Adjust based on AppBar height
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                // HomeNavBar(),
                SizedBox(height: 40),
                Container(
                  // temp height
                  padding: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(35),
                    //   topRight: Radius.circular(35),
                    // ),
                  ),
                  child: Column(
                    children: [
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
                      // search bar!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
                      // categories!!!!!!!!!!!!!!!!!!
                      CategoriesWidget(),

                      // items!!!!!!!!!!!!
                      Container(
                        alignment: Alignment.centerLeft,
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Text(
                          "Today's Prices",
                          style: GoogleFonts.phudu(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // items widget!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
