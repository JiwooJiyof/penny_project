import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/select_product_dialog.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SharePriceDialog extends StatefulWidget {
  final int prodId;
  final String prodName;
  final int storeIndex;
  final store;

  const SharePriceDialog(
      {Key? key,
      required this.prodId,
      required this.prodName,
      required this.storeIndex,
      required this.store})
      : super(key: key);

  @override
  State<SharePriceDialog> createState() => _SharePriceDialogState();
}

class _SharePriceDialogState extends State<SharePriceDialog> {
  List<bool> isOnSaleSelected = [
    false,
    true // no default
  ];
  List<bool> howIsPricedSelected = [
    true, // total default
    false
  ];
  List<bool> howIsMeasuredSelected = [
    false,
    false,
    true // per lb default
  ];

  TextEditingController priceController = TextEditingController();
  double enteredPrice = 0.0;
  String selectedUnit = '/lb';

  Future<void> updatePrice(int id, double price, String unit) async {
    try {
      // print(id);
      // print(price);
      // print(unit);
      final response = await http.patch(
        Uri.parse('http://127.0.0.1:8000/items/$id/'),
        body: {
          'price': price.toString(),
          'unit_system': unit,
        },
      );

      if (response.statusCode == 200) {
        print('Price updated successfully');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _navigateBack(BuildContext context) {
    Navigator.pop(context); // pop current dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => SelectProductDialog(
          storeIndex: widget.storeIndex, store: widget.store),
      barrierDismissible: true,
    );
  }

  // toggle button selection
  void _handleIsOnSaleToggle(int index) {
    setState(() {
      isOnSaleSelected = isOnSaleSelected.map((e) => false).toList();
      isOnSaleSelected[index] = true;
    });
  }

  void _handleHowIsPricedToggle(int index) {
    setState(() {
      howIsPricedSelected = howIsPricedSelected.map((e) => false).toList();
      howIsPricedSelected[index] = true;

      // show/hide the "how is it measured"
      if (index == 0) {
        howIsMeasuredSelected = [false, false, false];
      } else {
        howIsMeasuredSelected = [false, false, true];
      }
    });
  }

  void _handleHowIsMeasuredToggle(int index) {
    setState(() {
      howIsMeasuredSelected = howIsMeasuredSelected.map((e) => false).toList();
      howIsMeasuredSelected[index] = true;

      // update the selected unit
      if (index == 0) {
        selectedUnit = '/g';
      } else if (index == 1) {
        selectedUnit = '/kg';
      } else if (index == 2) {
        selectedUnit = '/lb';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    priceController.addListener(() {
      setState(() {
        enteredPrice = double.tryParse(priceController.text) ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(
                  color: Colors.black,
                  onPressed: () => _navigateBack(context),
                ),
                Expanded(
                  child: Text(
                    'Share your price!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.phudu(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            // SizedBox for spacing
            SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Enter price:'),
                        SizedBox(height: 8), // Spacing
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  '\$',
                                  style: TextStyle(color: Colors.amber),
                                ),
                                SizedBox(width: 5.0),
                                Expanded(
                                  child: TextField(
                                    controller: priceController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}$')),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'Enter the price',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 16), // Spacing
                        // Text('Is this on sale?'),
                        // _buildToggleButtons(
                        //   isSelected: isOnSaleSelected,
                        //   labels: ['Yes', 'No'],
                        //   onPressed: _handleIsOnSaleToggle,
                        // ),
                        // SizedBox(height: 8), // Spacing
                        Text('How is it priced?'),
                        _buildToggleButtons(
                          isSelected: howIsPricedSelected,
                          labels: ['total', 'by unit'],
                          onPressed: _handleHowIsPricedToggle,
                        ),
                        if (howIsPricedSelected[
                            1]) // Show only if "by unit" is selected
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text('How is it measured?'),
                              _buildToggleButtons(
                                isSelected: howIsMeasuredSelected,
                                labels: ['per g', 'per kg', 'per lb'],
                                onPressed: _handleHowIsMeasuredToggle,
                              ),
                            ],
                          ),
                        SizedBox(height: 16), // Spacing
                        // "Update" button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              updatePrice(
                                  widget.prodId, enteredPrice, selectedUnit);
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                child: Text('Update!',
                                    style: TextStyle(fontSize: 16))),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black, // Button color
                              onPrimary: Colors.white, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 5, // Optional: Adjust elevation
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: _buildProductCard(
                      productName: widget.prodName,
                      productDetails:
                          '${widget.store['name']}, ${widget.store['location']}',
                      imagePath: 'assets/products/1.png',
                      price: enteredPrice,
                      unit: selectedUnit,
                      isByUnit: howIsPricedSelected[1],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons({
    required List<bool> isSelected,
    required List<String> labels,
    required void Function(int) onPressed,
    bool showToggle = true,
  }) {
    List<Widget> children = labels
        .map((label) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(label),
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: showToggle // check if the toggle should be displayed
          ? ToggleButtons(
              children: children,
              isSelected: isSelected,
              onPressed: onPressed,
              borderRadius: BorderRadius.circular(20),
              color: Colors.black,
              fillColor: Colors.black, // bkgd colour when selected
              selectedColor: Colors.white, // text colour when selected
              borderColor: Colors.black,
              selectedBorderColor: Colors.black,
              borderWidth: 1,
              constraints: BoxConstraints(
                minHeight: 36.0,
              ),
            )
          : Container(), // if not, return  empty container
    );
  }

  Widget _buildProductCard({
    required String productName,
    String productDetails = 'Product details\nGrocery Store, Address',
    String imagePath = "assets/products/1.png",
    double price = 10.0,
    required String unit,
    required bool isByUnit,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: GoogleFonts.phudu(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              productDetails,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Image.asset(
                  imagePath,
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "\$$price",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isByUnit) // display the unit only if "by unit" is selected
                    Text(
                      unit,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
