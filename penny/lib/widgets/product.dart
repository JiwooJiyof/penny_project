import 'package:flutter/material.dart';
import 'package:penny/widgets/product_dialog.dart';

class ProductWidget extends StatefulWidget {
  final String path;

  ProductWidget({required this.path});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  int? hoveredIndex; // item that is being hovered over

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double minContainerSize = 250; // min container size?
    int containersPerRow = (screenWidth / minContainerSize).floor();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: containersPerRow,
        childAspectRatio: 0.8,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 7,
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) {
            setState(() {
              hoveredIndex = index;
            });
          },
          onExit: (_) {
            setState(() {
              hoveredIndex = null;
            });
          },
          child: GestureDetector(
            onTap: () {
              showProductDetailsDialog(context, index); // open prod details
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: hoveredIndex == index
                        ? Colors.amber
                        : Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // product name ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
                  // store ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
                  // product image ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/products/${widget.path}${index + 1}.png",
                      height: 120,
                      width: 120,
                    ),
                  ),
                  // product description ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
                  // product price ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
          ),
        );
      },
    );
  }
}
