import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/select_product_dialog.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SharePriceDialog extends StatefulWidget {
  // final String prodId;
  // final String prodName;
  final int storeIndex;
  final product;
  final store;

  const SharePriceDialog(
      {Key? key,
      // required this.prodId,
      // required this.prodName,
      required this.product,
      required this.storeIndex,
      required this.store})
      : super(key: key);

  @override
  State<SharePriceDialog> createState() => _SharePriceDialogState();
}

class _SharePriceDialogState extends State<SharePriceDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isUpdated = false; // New state variable

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
  String selectedUnit = 'lb';

  Future<void> updatePrice(String id, String price, String unit) async {
    try {
      // print(id);
      // print(price);
      // print(unit);
      final response = await http.patch(
        Uri.parse('http://127.0.0.1:8000/items/$id/'),
        body: {
          'price': price,
          'unit_system': unit,
        },
      );

      if (response.statusCode == 200) {
        print('Price updated successfully');
        setState(() {
          isUpdated = true; // update the state to show success msg
        });
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
        selectedUnit = 'ea';
      } else {
        howIsMeasuredSelected = [false, false, true];
        selectedUnit = 'lb';
      }
    });
  }

  void _handleHowIsMeasuredToggle(int index) {
    setState(() {
      howIsMeasuredSelected = howIsMeasuredSelected.map((e) => false).toList();
      howIsMeasuredSelected[index] = true;

      // update the selected unit
      if (index == 0) {
        selectedUnit = '100g';
      } else if (index == 1) {
        selectedUnit = 'kg';
      } else if (index == 2) {
        selectedUnit = 'lb';
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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: isUpdated ? _buildSuccessContent() : _buildFormContent(),
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
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
                'Price updated!',
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
        Text(
          'Thanks for your contribution!',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 16),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: _buildProductCard(
            productName: widget.product['name'],
            productDetails:
                '${widget.store['name']}, ${widget.store['location']}',
            imagePath:
                widget.product['image_url'], // TODO: Replace w/ image url
            price: enteredPrice,
            unit: selectedUnit,
            isByUnit: howIsPricedSelected[1],
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Column(
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
        SizedBox(height: 20), // spacing
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // enter price ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: priceController,
                        cursorColor: Colors.amber,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Enter price',
                          labelStyle: TextStyle(
                              color: Colors.black), // black label style
                          focusedBorder: OutlineInputBorder(
                            // amber focused border
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // style when TextField is enabled
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text('\$',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null; // null if the input is valid
                        },
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
                    // unit system ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
                    // update button ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // check if form is valid
                            updatePrice(widget.product['id'],
                                enteredPrice.toStringAsFixed(2), selectedUnit);
                          }
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
              // product card ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              Expanded(
                flex: 1,
                child: _buildProductCard(
                  productName: widget.product['name'],
                  productDetails:
                      '${widget.store['name']}, ${widget.store['location']}',
                  imagePath:
                      widget.product['image_url'], // TODO: Replace w/ image url
                  price: enteredPrice,
                  unit: selectedUnit,
                  isByUnit: howIsPricedSelected[1],
                ),
              ),
            ],
          ),
        ),
      ],
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
    String imagePath = "",
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
            // product name ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            Text(
              productName,
              style: GoogleFonts.phudu(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            // product details ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            Text(
              productDetails,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            // product image ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: Image.network(
                  'http://127.0.0.1:8000/items/proxy_image/?url=${Uri.encodeComponent(imagePath)}',
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    print('Image load error: $exception');
                    if (stackTrace != null) {
                      print('Stack trace: $stackTrace');
                    }
                    return Icon(
                      Icons.local_grocery_store,
                      size: 100,
                      color: Colors.amber,
                    );
                  },
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
                    "\$" +
                        price.toStringAsFixed(
                            2), // format price to 2 decimal places
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (isByUnit) // display the unit only if "by unit" is selected
                    Text(
                      '/' + unit,
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
