import 'package:flutter/material.dart';

class StoreWidget extends StatelessWidget {
  dynamic stores; // store fetched stores
  dynamic prod; // store fetched stores

  StoreWidget({required this.stores, required this.prod});
  @override
  Widget build(BuildContext context) {
    // Get the screen width
    // print(
    //     "WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP WAKE UP !!!!!!!!!!!!!");
    // print(stores);
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the width for each container based on the screen width and the desired number of items per row
    double containerWidth = (screenWidth - 40) /
        3; // 40 is the total horizontal margin (20 margin on each side)

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // Add childAspectRatio to control the size ratio of the card
        childAspectRatio: 1 / 1.2,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: stores.length,
      itemBuilder: (context, index) {
        dynamic store = stores[index];

        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(15),
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
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    store['store_name'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.store,
                      size: 80,
                    ),
                    // child: Image.asset(
                    //   "assets/products/$path${index + 1}.png",
                    //   // Remove fixed height and let the image expand
                    //   width: double
                    //       .infinity, // make image take all horizontal space
                    //   fit: BoxFit.cover, // cover the space without distortion
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LocationButton(),
                      Row(
                        children: [
                          Text(
                            "\$${store['price']}",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            "/${prod['unit_system']}",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // return GridView.builder(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 3,
    //     // childAspectRatio: null, // Set to null for dynamic aspect ratio
    //   ),
    //   physics: NeverScrollableScrollPhysics(),
    //   shrinkWrap: true,
    //   itemCount: 7,
    //   itemBuilder: (context, index) {
    //     return Container(
    //       margin: EdgeInsets.all(10),
    //       padding: EdgeInsets.all(20),
    //       width: containerWidth,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(20),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.grey.withOpacity(0.3),
    //             spreadRadius: 2,
    //             blurRadius: 7,
    //             offset: const Offset(0, 3),
    //           ),
    //         ],
    //       ),
    //       child: Column(
    //         children: [
    //           Container(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               "Store Name",
    //               style: TextStyle(
    //                 fontSize: 16,
    //                 color: Colors.black,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               "Address",
    //               style: TextStyle(
    //                 fontSize: 14,
    //                 color: Colors.black,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             margin: EdgeInsets.all(10),
    //             child: InkWell(
    //               onTap: () {},
    //               child: Image.asset(
    //                 "assets/products/$path${index + 1}.png",
    //                 height: containerWidth -
    //                     40, // Adjust the image height based on container width
    //                 width: containerWidth -
    //                     40, // Adjust the image width based on container width
    //               ),
    //             ),
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               // OVER HERE!
    //               LocationButton(),
    //               Row(
    //                 children: [
    //                   Text(
    //                     "\$10",
    //                     style: TextStyle(
    //                         fontSize: 25,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.black),
    //                   ),
    //                   Text(
    //                     "/unit",
    //                     style: TextStyle(fontSize: 12, color: Colors.black),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}

class LocationButton extends StatefulWidget {
  @override
  _LocationButtonState createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: redirect to external maps?
        print("Location button tapped!");
      },
      onHover: (hovered) {
        setState(() {
          isHovered = hovered;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isHovered ? Colors.amber : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.location_on,
            size: 18,
            color: isHovered ? Colors.white : Colors.amber,
          ),
        ),
      ),
    );
  }
}
