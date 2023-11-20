import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/widgets/store.dart';

void showProductDetailsDialog(BuildContext context, int index) {
  String? selectedSortOption = 'distance'; // Initial value for the dropdown

  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.all(20),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  // button to close pop-up
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // prod name ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        Text(
                          "Product Name",
                          style: GoogleFonts.phudu(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // prod description ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        Text(
                          "Product description",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        // prod image ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        Center(
                          child: Image.asset(
                            "assets/products/${index + 1}.png",
                            height: 200,
                            width: 200,
                          ),
                        ),
                        SizedBox(height: 20),
                        // store availability ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Available at",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            // sort dropdown ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                            Row(
                              children: [
                                Icon(Icons.sort,
                                    color: Colors.amber), // prefix icon
                                SizedBox(width: 8),
                                // dropdown Button
                                DropdownButton<String>(
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text('Distance'),
                                      value: 'distance',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Price: Low to High'),
                                      value: 'lowToHigh',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Price: High to Low'),
                                      value: 'highToLow',
                                    ),
                                  ],
                                  onChanged: (String? value) {
                                    // update dropdown val
                                    setState(() {
                                      selectedSortOption = value;
                                    });
                                    // You can implement sorting logic based on the selected option
                                  },
                                  hint: Text('Sort by'),
                                  value:
                                      selectedSortOption, // Set the default value to the first dropdown item
                                  dropdownColor: Colors
                                      .white, // Set the dropdown background color
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: Colors
                                          .amber), // Set the dropdown arrow color
                                  underline: Container(
                                    height: 2,
                                    color:
                                        Colors.amber, // Set the underline color
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // stores ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        StoreWidget(path: "rawr"),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
    barrierDismissible: true, // Allow dismissing by tapping outside the dialog
    barrierColor: Colors.black.withOpacity(0.5),
    barrierLabel: "Close",
    transitionDuration: Duration(milliseconds: 300),
  );
}
