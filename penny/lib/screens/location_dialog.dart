import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Assuming the following custom styles are similar to those in the image:
    const titleStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black, // Adjust the color to match the image
    );
    const buttonTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black, // Adjust the color to match the image
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
                // Using Align to center the title
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Select your current location',
                    style: GoogleFonts.phudu(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                // Positioned to place the close button on the right
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25), // Spacing between text and search bar
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
                  hintText: 'Search for a product...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
            ),
            SizedBox(height: 50), // Spacing between search bar and grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: (1 / .6),
                children: List.generate(9, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align text to the start (left)
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Placeholder for store logo
                          Icon(Icons.store,
                              size: 50), // Replace with actual logo
                          SizedBox(height: 8), // Spacing between logo and text
                          Text(
                            'Store Name', // Replace with actual store name
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Grocery Store Address', // Replace with actual address
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
