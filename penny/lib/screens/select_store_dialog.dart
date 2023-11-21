import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/select_product_dialog.dart';

class SelectStoreDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black, // black text
    );
    const buttonTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black, // black
    );

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
                // title ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                Align(
                  alignment: Alignment.center, // centered
                  child: Text(
                    'Select your current location',
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
                  hintText: 'Search for a location...',
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
                  return StoreGridItem(index: index);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreGridItem extends StatefulWidget {
  final int index;

  const StoreGridItem({Key? key, required this.index}) : super(key: key);

  @override
  _StoreGridItemState createState() => _StoreGridItemState();
}

class _StoreGridItemState extends State<StoreGridItem> {
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
              return SelectProductDialog(index: widget.index);
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
                Text('Store Name',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                // Text('Grocery Store Address', style: TextStyle(fontSize: 14)),
                SizedBox(height: 8),
                Center(
                    child: Icon(Icons.store,
                        size: 50)), // TODO: replace with actual logo
              ],
            ),
          ),
        ),
      ),
    );
  }
}