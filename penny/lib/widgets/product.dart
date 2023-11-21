import 'package:flutter/material.dart';
import 'package:penny/widgets/product_dialog.dart';

class ProductWidget extends StatelessWidget {
  final String path;

  ProductWidget({required this.path});
  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Decide on a minimum size for the square containers
    double minContainerSize = 250; // example value, adjust as needed

    // Calculate number of containers that can fit in a row
    int containersPerRow = (screenWidth / minContainerSize).floor();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: containersPerRow,
        childAspectRatio: 0.8, // square containers
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 7,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            showProductDetailsDialog(context, index);
          },
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Product Name",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Grocery Store",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/products/$path${index + 1}.png",
                    height: 120,
                    width: 120,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Product description",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "\$10",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        "/unit",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
