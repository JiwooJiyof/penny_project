import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:penny/widgets/categories.dart';
import 'package:penny/widgets/nav_bar.dart';
import 'package:penny/widgets/search_bar.dart';
import 'package:penny/widgets/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/search_page.dart';
import 'package:penny/screens/select_store_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final LocationData? locationData;

  HomePage({Key? key, this.locationData}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late String searchText;
  dynamic result;
  int resultCount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response =
        await http.get(Uri.parse('https://boolean-boos.onrender.com/items/'));
    if (response.statusCode == 200) {
      setState(() {
        result = json.decode(response.body)['results'];
        resultCount = result.length;
        print(result);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SelectStoreDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // nav bar ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          NavBar(),
          Expanded(
            child: Stack(
              children: [
                // background ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                Positioned.fill(
                  child: Image.asset(
                    'assets/main_page.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // other stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                SingleChildScrollView(
                  padding: EdgeInsets.all(30),
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
                      // search bar ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      Search(
                        controller: _searchController,
                        onSearch: (searchTerm) async {
                          searchText = searchTerm;
                          var response = await http.get(Uri.parse(
                              'https://boolean-boos.onrender.com/items/?ordering=price&name=$searchText')); // sort low to high by default

                          if (response.statusCode == 200) {
                            // success: parse json
                            Map<String, dynamic> jsonData =
                                json.decode(response.body);

                            result = jsonData['results'];
                            resultCount = result.length;
                          } else {
                            print(
                                'Request failed with status: ${response.statusCode}.');
                          }
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SearchPage(
                                searchText: _searchController.text,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return child; // no animation, just return the child
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 80),
                      // categories ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      // CategoriesWidget(),
                      // today's prices ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
                      // products ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      ProductWidget(
                        result: result,
                      ),
                    ],
                  ),
                ),
                // log price button ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
