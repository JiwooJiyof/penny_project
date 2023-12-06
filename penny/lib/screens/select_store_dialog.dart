import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/select_product_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectStoreDialog extends StatefulWidget {
  @override
  State<SelectStoreDialog> createState() => _SelectStoreDialogState();
}

class _SelectStoreDialogState extends State<SelectStoreDialog> {
  dynamic storeData; // response data

  @override
  void initState() {
    super.initState();
    storeData = getStores();
  }

  Future<List<dynamic>> getStores() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/stores/'),
      );

      if (response.statusCode == 200) {
        // successful response
        final decodedData = json.decode(response.body)['results'];
        return decodedData;
      } else {
        // error response
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      //exceptions
      print('Error: $error');
      return [];
    }
  }

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

    return FutureBuilder<List<dynamic>>(
      future: storeData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // error
        } else {
          final List<dynamic> storeData = snapshot.data ?? []; // access data

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
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 100),
                  //   padding: EdgeInsets.symmetric(horizontal: 15),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(30),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.3),
                  //         spreadRadius: 2,
                  //         blurRadius: 7,
                  //         offset: const Offset(0, 3),
                  //       ),
                  //     ],
                  //   ),
                  //   child: TextField(
                  //     cursorColor: Colors.amber,
                  //     decoration: InputDecoration(
                  //       suffixIcon: InkWell(
                  //         onTap: () {},
                  //         child: Icon(Icons.search, color: Colors.amber),
                  //       ),
                  //       hintText: 'Search for a location...',
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(30),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //       contentPadding: EdgeInsets.all(20),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 50),
                  // stores grid view ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1 / 0.6,
                      padding: EdgeInsets.all(20), // padding
                      children: List.generate(storeData.length, (index) {
                        return StoreGridItem(
                          index: index,
                          stores:
                              storeData, // Assuming responseData is now a list of stores
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class StoreGridItem extends StatefulWidget {
  final int index;
  final List<dynamic> stores;

  const StoreGridItem({
    Key? key,
    required this.index,
    required this.stores, // Add this parameter
  }) : super(key: key);

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

    final storeInfo = widget.stores[widget.index];
    // print(
    //     "slayyyyyyy   slayyyyyyy   slayyyyyyy   slayyyyyyy   slayyyyyyy   slayyyyyyy   slayyyyyyy   slayyyyyyy   slayyyyyyy   slayyyyyyy   slayyyyyyy");
    // print(widget.index);
    // print(responseData);

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
              return SelectProductDialog(
                  storeIndex: widget.index, store: storeInfo);
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
              children: [
                Text(
                  storeInfo['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(storeInfo['location'], style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Expanded(
                  // Use Expanded here
                  child: Center(
                    child: Image.asset(
                      'stores/${storeInfo['name'].replaceAll(' ', '')}.png',
                      fit: BoxFit
                          .contain, // BoxFit.contain to fit the image within the container
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
