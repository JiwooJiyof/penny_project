import 'package:flutter/material.dart';
import 'package:penny/widgets/home_nav_bar.dart';
import 'package:penny/widgets/product.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  final String inputText;

  SearchPage({required this.inputText});

  @override
  _SearchPageState createState() => _SearchPageState(inputText: inputText);
}

class _SearchPageState extends State<SearchPage> {
  String inputText;
  String selectedSortOption;

  _SearchPageState({required this.inputText})
      : selectedSortOption = 'Lowest to Highest Price';

  final TextEditingController _controller = TextEditingController();

  // sorting options
  List<String> sortOptions = [
    'Lowest to Highest Price',
    'Highest to Lowest Price',
    'By Name'
  ];

  @override
  void initState() {
    super.initState();
    _controller.text = inputText;
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
            child: HomeNavBar(),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/main_page.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60),
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Container(
                  // temp height
                  padding: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
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
                          controller: _controller,
                          cursorColor: Colors.amber,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                // navigate to the SearchPage when the search icon is clicked
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                      inputText: _controller.text,
                                    ),
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
                      SizedBox(height: 40),

                      // items widget ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '7 results found',
                            style: GoogleFonts.phudu(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          // sort dropdown ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
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
                                        color: Colors
                                            .amber), // Dropdown arrow to the right
                                    value: selectedSortOption,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          selectedSortOption = newValue;
                                          // TODO: Add sorting logic
                                        });
                                      }
                                    },
                                    items: sortOptions.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Row(
                                          children: [
                                            Text(option,
                                                style: TextStyle(
                                                    color: Colors.black)),
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
                      ProductWidget(path: "straw"),
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
