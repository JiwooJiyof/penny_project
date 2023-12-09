import 'package:flutter/material.dart';

Widget buildNetworkImage(String? imageUrl, double size) {
  if (imageUrl == null || imageUrl.isEmpty) {
    // Return a default icon if the URL is null or empty
    return Icon(
      Icons.local_grocery_store,
      size: 100,
      color: Colors.amber,
    );
  }

  // Construct the full URL for the image
  String fullUrl =
      'https://boolean-boos.onrender.com/items/proxy_image/?url=${Uri.encodeComponent(imageUrl)}';

  return Image.network(
    fullUrl,
    height: size > 0 ? size : null,
    width: size > 0 ? size : null,
    fit: BoxFit.contain,
    errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      print('Image load error: $exception');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
      // Return a default icon if there's an error loading the image
      return Icon(
        Icons.local_grocery_store,
        size: 100,
        color: Colors.amber,
      );
    },
  );
}

// Usage in your widget tree
// child: _buildNetworkImage(product['image_url']),
