import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/select_store_dialog.dart';
import 'package:penny/screens/share_price_dialog.dart';

class SelectProductDialog extends StatelessWidget {
  final int index;

  const SelectProductDialog({Key? key, required this.index}) : super(key: key);

  void _navigateBack(BuildContext context) {
    // Pop the current dialog
    Navigator.pop(context);
    // Show the previous dialog again
    showDialog(
      context: context,
      builder: (BuildContext context) => SelectStoreDialog(),
      barrierDismissible:
          true, // Set to false if you do not want to dismiss the dialog by tapping outside of it.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                // back button ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                Positioned(
                  // on the left
                  left: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => _navigateBack(context),
                  ),
                ),
                // title ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                Align(
                  alignment: Alignment.center, // centered
                  child: Text(
                    'Select an item to price check',
                    style: GoogleFonts.phudu(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                // close button ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                Positioned(
                  // on the right
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
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
                cursorColor: Colors.amber,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {},
                    child: Icon(Icons.search, color: Colors.amber),
                  ),
                  hintText: 'Search for an item...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
            ),
            SizedBox(height: 50),
            // stores grid view ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
                childAspectRatio: (1 / .6),
                padding: EdgeInsets.all(20), // padding
                children: List.generate(12, (index) {
                  return ProductGridItem(index: index);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductGridItem extends StatefulWidget {
  final int index;

  const ProductGridItem({Key? key, required this.index}) : super(key: key);

  @override
  _ProductGridItemState createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final boxShadow = _isHovered
        ? BoxShadow(
            color: Colors.amber.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        : BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          // Pop the current dialog
          Navigator.pop(context);
          // Open the new dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SharePriceDialog(index: widget.index);
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            boxShadow: [boxShadow],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Product Name',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Product details', style: TextStyle(fontSize: 14)),
                SizedBox(height: 8),
                Center(
                    child: Icon(Icons.apple,
                        size: 50)), // TODO: replace with actual logo
              ],
            ),
          ),
        ),
      ),
    );
  }
}
