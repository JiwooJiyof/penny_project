import 'package:flutter/material.dart';
import 'package:penny/widgets/product_dialog.dart';

class ProductWidget extends StatefulWidget {
  final dynamic result;

  ProductWidget({
    required this.result,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  int? hoveredIndex; // item that is being hovered over
  late dynamic result;

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
      itemCount: widget.result.length,
      itemBuilder: (context, index) {
        dynamic product = widget.result[index];

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
              showProductDetailsDialog(
                  context, index, product); // open prod details
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
                      product['name'],
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
                      product['store_name'],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // product image ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Image.network(
                      product['image_url'] ?? '',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Icon(
                          Icons.local_grocery_store,
                          size: 100,
                          color: Colors.amber,
                        );
                      },
                    ),
                  ),
                  // product description ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     "Product description",
                  //     style: TextStyle(
                  //       fontSize: 15,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                  // product price ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "\$${product['price']}",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          "/${product['unit_system']}",
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
