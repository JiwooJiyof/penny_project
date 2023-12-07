import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/widgets/store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

dynamic globalFetchedStores; // store fetched stores
String ordering = 'distance'; // Default ordering value

Future<dynamic> fetchData(dynamic product, String ordering) async {
  var response = await http.get(Uri.parse(
      'https://boolean-boos.onrender.com/items/detail/?ordering=$ordering&name=${product['name']}'));
  if (response.statusCode == 200) {
    globalFetchedStores = json.decode(
        response.body)['stores_with_item']; // Store data in the global variable
  } else {
    print('Request failed with status: ${response.statusCode}.');
    globalFetchedStores = null; // Set to null or appropriate value on failure
  }
}

void showProductDetailsDialog(
    BuildContext context, int index, dynamic product) async {
  String? selectedSortOption = 'distance'; // Initial value for the dropdown
  await fetchData(product, ordering);

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
                margin: EdgeInsets.all(10), // Added margin around the dialog
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                      flexibleSpace: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          double top = constraints.biggest.height;
                          bool isCollapsed = top <= kToolbarHeight;
                          double scale =
                              (top - kToolbarHeight) / (200.0 - kToolbarHeight);
                          scale = scale.clamp(0.0, 1.0);

                          double imageSize = isCollapsed ? 40 : 180 * scale;
                          double titleSize = isCollapsed ? 18 : 30 * scale;
                          double descriptionSize =
                              isCollapsed ? 14 : 15 * scale;

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // Positioned image on the left that scales down
                              Positioned(
                                top: isCollapsed
                                    ? (kToolbarHeight - imageSize) / 2
                                    : top - imageSize - 20,
                                left: 20, // Fixed left position
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Image.network(
                                    'http://127.0.0.1:8000/items/proxy_image/?url=${Uri.encodeComponent(product['image_url'])}',
                                    height: imageSize,
                                    width: imageSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Icon(
                                        Icons.local_grocery_store,
                                        size: imageSize,
                                        color: Colors.amber,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Positioned title text that scales down
                              Positioned(
                                top: isCollapsed
                                    ? (kToolbarHeight - titleSize) / 2
                                    : top - titleSize - 60,
                                left: imageSize +
                                    (isCollapsed
                                        ? 30
                                        : 40), // Adjusted left position for collapsed state
                                child: Text(
                                  product['name'],
                                  style: GoogleFonts.phudu(
                                    fontSize: titleSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Positioned description text that fades out
                              // Positioned(
                              //   top: isCollapsed
                              //       ? (kToolbarHeight - descriptionSize) / 2
                              //       : top - descriptionSize - 40,
                              //   left: imageSize +
                              //       40, // Left position aligned with title text
                              //   child: Opacity(
                              //     opacity: scale,
                              //     child: Text(
                              //       "Product description",
                              //       style: TextStyle(
                              //         fontSize: descriptionSize,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Close button is already positioned correctly
                            ],
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10), // Adjust the padding as needed
                            child:
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
                                          // Set the ordering variable based on the selected option
                                          if (selectedSortOption ==
                                              'lowToHigh') {
                                            ordering = '-price';
                                          } else if (selectedSortOption ==
                                              'highToLow') {
                                            ordering = 'price';
                                          } else if (selectedSortOption ==
                                              'distance') {
                                            ordering = 'distance';
                                          }
                                          // You can implement sorting logic based on the selected option
                                          fetchData(product, ordering);
                                        });
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
                                        color: Colors
                                            .amber, // Set the underline color
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // stores ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: StoreWidget(
                                stores: globalFetchedStores, prod: product),
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
      );
    },
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    barrierLabel: "Close",
    transitionDuration: Duration(milliseconds: 300),
  );
}
