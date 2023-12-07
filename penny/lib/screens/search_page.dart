import 'package:flutter/material.dart';
import 'package:penny/screens/home_page.dart';
import 'package:penny/widgets/nav_bar.dart';
import 'package:penny/widgets/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  final String searchText;
  // final dynamic result;
  // final int resultCount;

  SearchPage({
    required this.searchText,
    // required this.result,
    // required this.resultCount,
  });

  @override
  _SearchPageState createState() => _SearchPageState(searchText: searchText);
}

class _SearchPageState extends State<SearchPage> {
  String searchText;
  String selectedSortOption;
  String ordering = 'price';
  final TextEditingController _searchController = TextEditingController();
  late int resultCount; // late initialization
  late dynamic result;

  _SearchPageState({required this.searchText})
      : selectedSortOption = 'Price: Lowest to Highest';

  final TextEditingController _controller = TextEditingController();

  // sorting options
  List<String> sortOptions = [
    'Price: Lowest to Highest',
    'Price: Highest to Lowest',
  ];

  @override
  void initState() {
    super.initState();
    searchText = widget.searchText;
    selectedSortOption = 'Price: Lowest to Highest';
    _searchController.text =
        searchText; // set the initial value of the search bar
    resultCount = 0;
    result = [];

    // _controller.text = searchText;
    _performSearch('price');
  }

  Future<void> _performSearch(String ordering) async {
    var response = await http.get(Uri.parse(
        'https://boolean-boos.onrender.com/items/?ordering=$ordering&name=$searchText'));

    if (response.statusCode == 200) {
      // sucessful
      Map<String, dynamic> jsonData =
          json.decode(response.body); // parse to json

      setState(() {
        result = jsonData['results'];
        resultCount = result.length;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(showBackButton: true),
          ),
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/main_page.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(top: 60),
            child: ListView(
              padding: EdgeInsets.all(30),
              children: [
                Container(
                  // temp height
                  padding: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            // Replace with your navigation logic
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        HomePage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return child; // no animation, just return the child
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Penny',
                            style: GoogleFonts.phudu(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 50),
                      // search bar ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
                              onTap: () => _executeSearch(),
                              child: Icon(Icons.search, color: Colors.amber),
                            ),
                            hintText: 'Search for a product...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          onSubmitted: (value) => _executeSearch(),
                        ),
                      ),
                      SizedBox(height: 60),

                      // items widget ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${resultCount} results found',
                              style: GoogleFonts.phudu(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          // sort dropdown ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // border:
                                //     Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.sort,
                                      color: Colors.amber), // prefix icon
                                  SizedBox(width: 8),
                                  // dropdown Button
                                  DropdownButton<String>(
                                    dropdownColor: Colors.white,
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.amber), // dropdown arrow
                                    value: selectedSortOption,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          selectedSortOption = newValue;
                                          // set ordering variable
                                          if (selectedSortOption ==
                                              'Price: Lowest to Highest') {
                                            ordering = 'price';
                                          } else if (selectedSortOption ==
                                              'Price: Highest to Lowest') {
                                            ordering = '-price';
                                          }
                                          _performSearch(
                                              ordering); // regenerate items
                                        });
                                      }
                                    },
                                    items: sortOptions.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Row(
                                          children: [
                                            Text(
                                              option,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            SizedBox(width: 8),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    underline: SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // items widget
                      ProductWidget(result: result),
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

  void _executeSearch() async {
    searchText = _searchController.text; // user input

    await _performSearch(ordering); // search

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SearchPage(
          searchText: _searchController.text,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child; // no animation, just return the child
        },
      ),
    );
  }
}
