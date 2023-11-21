import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:penny/widgets/categories.dart';
import 'package:penny/widgets/home_nav_bar.dart';
import 'package:penny/widgets/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/search_page.dart';
import 'package:penny/screens/select_location_dialog.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final LocationData? locationData;
  late String searchText; // searchText variable
  dynamic result; // Move these declarations to the class level
  int resultCount = 0;

  HomePage({Key? key, this.locationData}) : super(key: key);

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => LocationDialog(),
    );
  }

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
                              onTap: () async {
                                // Store user input in searchText
                                searchText = _searchController.text;
                                // Make the GET request to your API endpoint
                                var response = await http.get(Uri.parse(
                                    'http://127.0.0.1:8000/items/?name=$searchText'));

                                // Check if the request was successful
                                if (response.statusCode == 200) {
                                  // If the call to the server was successful, parse the JSON
                                  Map<String, dynamic> jsonData =
                                      json.decode(response.body);

                                  print(
                                      "Response data: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                                  result = jsonData['results'];
                                  resultCount = result.length;

                                  // print(jsonData['results']);
                                  // print(jsonData['results'].length);
                                } else {
                                  // If the server did not return a "200 OK response",
                                  // then throw an exception.
                                  print(
                                      'Request failed with status: ${response.statusCode}.');
                                }

                                // Navigate to the SearchPage with the search text
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        SearchPage(
                                      inputText: _searchController.text,
                                      result: result,
                                      resultCount: resultCount,
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return child; // no animation, just return the child
                                    },
                                  ),
                                );
                              },
                              // onTap: () {
                              //   // Navigate to the SearchPage when the search icon is clicked
                              //   Navigator.push(
                              //     context,
                              //     PageRouteBuilder(
                              //       pageBuilder: (context, animation,
                              //               secondaryAnimation) =>
                              //           SearchPage(
                              //         inputText: _searchController.text,
                              //       ),
                              //       transitionsBuilder: (context, animation,
                              //           secondaryAnimation, child) {
                              //         return child; // no animation, just return the child
                              //       },
                              //     ),
                              //   );
                              // },
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
                      ProductWidget(path: ""),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 32, // padding from the bottom edge
                  right: 32, // padding from the right edge
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.label_outlined, size: 24),
                    label: Text(
                      'Log Price',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () => _showLocationDialog(context),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber, // bkgd color
                      onPrimary: Colors.black, // text & icon color
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18), // padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // rounded corners
                      ),
                      textStyle: GoogleFonts.phudu(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
