import 'package:flutter/material.dart';

void showProductDetailsDialog(BuildContext context, int index) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
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
                // Button to close the pop-up
                // Positioned(
                //   top: 0,
                //   right: 0,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.white,
                //       onPrimary: Colors.black,
                //       shape: CircleBorder(),
                //       elevation: 0,
                //     ),
                //     child: Icon(Icons.close, color: Colors.black),
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //     },
                //   ),
                // ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Name",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Product description",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          "assets/products/${index + 1}.png",
                          height: 200,
                          width: 200,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      // Text(
                      //   "\$10",
                      //   style: TextStyle(
                      //       fontSize: 25,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.black),
                      // ),
                      // Text(
                      //   "/unit",
                      //   style: TextStyle(fontSize: 12, color: Colors.black),
                      // ),
                      Text(
                        "Available at",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Wrap(
                        spacing: 20, // Horizontal spacing between children
                        runSpacing: 5, // Vertical spacing between rows
                        children: [
                          for (int i = 1; i < 9; i++)
                            Container(
                              width: (MediaQuery.of(context).size.width * 0.7 -
                                      60) /
                                  2, // Minus 60 for the spacing and paddings
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/categories/7.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    // Added to make sure the text wraps if it's too long
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Grocery Store",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "Store address",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "\$${10 + i - 1}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    barrierDismissible: true, // Allow dismissing by tapping outside the dialog
    barrierColor: Colors.black.withOpacity(0.5),
    barrierLabel: "Close",
    transitionDuration: Duration(milliseconds: 300),
  );
}
