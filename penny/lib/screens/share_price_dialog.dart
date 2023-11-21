import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/select_item_dialog.dart';
import 'package:flutter/services.dart';

class SharePriceDialog extends StatefulWidget {
  final int index;

  const SharePriceDialog({Key? key, required this.index}) : super(key: key);

  @override
  State<SharePriceDialog> createState() => _SharePriceDialogState();
}

class _SharePriceDialogState extends State<SharePriceDialog> {
  List<bool> isOnSaleSelected = [
    false,
    true
  ]; // Assuming 'No' is initially selected
  List<bool> howIsPricedSelected = [
    true,
    false
  ]; // Assuming 'total' is initially selected
  List<bool> howIsMeasuredSelected = [
    false,
    false,
    true
  ]; // Assuming 'per lb' is initially selected

  TextEditingController priceController = TextEditingController();
  double enteredPrice = 0.0; // Updated price variable
  String selectedUnit = '/lb'; // Initialize with a default unit

  void _navigateBack(BuildContext context) {
    // Pop the current dialog
    Navigator.pop(context);
    // Show the ItemIndexDialog again
    showDialog(
      context: context,
      builder: (BuildContext context) => ItemIndexDialog(index: widget.index),
      barrierDismissible: true,
    );
  }

  // Methods to handle toggle button selection changes
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

      // Show/hide the "How is it measured" text and toggle based on the selection
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

      // Update the selected unit based on the index
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
    // Listen to changes in the text field and update enteredPrice accordingly
    priceController.addListener(() {
      setState(() {
        enteredPrice = double.tryParse(priceController.text) ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    // Dispose the controller to avoid memory leaks
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
        width: MediaQuery.of(context).size.width *
            0.9, // Adjust the dialog width if necessary
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top bar with back arrow, title, and close button
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
// Main content with toggles/actions on the left and product card on the right
            IntrinsicHeight(
              // Wrap with IntrinsicHeight to match the card's height with the left column
              child: Row(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // Stretch the children to fill the height
                children: [
                  // Left side elements (toggles, buttons)
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // New text and text box for entering price
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
                              // Handle the update action
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical:
                                        10.0), // Increase vertical padding for more height
                                child: Text('Update!',
                                    style: TextStyle(
                                        fontSize:
                                            16)) // Optional: Adjust font size if needed
                                ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black, // Button color
                              onPrimary: Colors.white, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              // ElevatedButton has a default elevation and padding which you can override here
                              elevation: 5, // Optional: Adjust elevation
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox for spacing between columns
                  SizedBox(width: 20),
                  // Right side - Product card
                  Expanded(
                    flex: 1,
                    child: _buildProductCard(
                      productName: 'French Baguette',
                      productDetails: 'Baked In Store\nGrocery Store',
                      imagePath: 'assets/products/1.png',
                      price: enteredPrice, // Use the updated enteredPrice
                      unit: selectedUnit,
                      isByUnit: howIsPricedSelected[1], // Pass the value here
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
    bool showToggle = true, // Add a parameter to control visibility
  }) {
    List<Widget> children = labels
        .map((label) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(label),
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: showToggle // Check if the toggle should be displayed
          ? ToggleButtons(
              children: children,
              isSelected: isSelected,
              onPressed: onPressed,
              borderRadius: BorderRadius.circular(20),
              color: Colors.black, // Text color
              fillColor: Colors.black, // Background color when selected
              selectedColor: Colors.white, // Text color when selected
              borderColor: Colors.black, // Border color
              selectedBorderColor: Colors.black, // Border color when selected
              borderWidth: 1, // Border width
              constraints: BoxConstraints(
                minHeight: 36.0, // Adjust the height here
                // minWidth: 88.0, // Minimum width for each toggle button
              ),
            )
          : Container(), // If not, return an empty container
    );
  }

  Widget _buildProductCard({
    String productName = 'Product name',
    String productDetails = 'Product details\nGrocery Store, Address',
    String imagePath = "assets/products/1.png",
    double price = 10.0,
    required String unit,
    required bool isByUnit, // Add a parameter to track if "by unit" is selected
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
                  if (isByUnit) // Display the unit only if "by unit" is selected
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
