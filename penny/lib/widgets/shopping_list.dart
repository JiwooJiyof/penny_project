import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ShoppingCartItem {
  String id;
  String name;
  bool isChecked;

  ShoppingCartItem({required this.id, this.name = '', this.isChecked = false});
}

class ShoppingCartDialog extends StatefulWidget {
  @override
  _ShoppingCartDialogState createState() => _ShoppingCartDialogState();
}

class _ShoppingCartDialogState extends State<ShoppingCartDialog> {
  List<ShoppingCartItem> items = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    final response = await http.get(Uri.parse('https://boolean-boos.onrender.com/shoppingcart/view/'));
    if (response.statusCode == 200) {
      final List<dynamic> itemsJson = json.decode(response.body);
      setState(() {
        items = itemsJson.map((jsonItem) => ShoppingCartItem(
            id: Uuid().v4(),
            name: jsonItem['item_name'],
            isChecked: jsonItem['is_checked']
        )).toList();
      });
    } else {
      // Handle errors or show a message
    }
  }

  Future<void> _updateCartItems() async {
    List<Map<String, dynamic>> payload = items.map((item) => {
      'item_name': item.name,
      'is_checked': item.isChecked
    }).toList();
    final response = await http.put(
      Uri.parse('https://boolean-boos.onrender.com/shoppingcart/update/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(payload),
    );
    if (response.statusCode != 200) {
      // Handle errors or show a message
    }
  }

  void _addItem() {
    setState(() {
      items.add(ShoppingCartItem(id: Uuid().v4()));
    });
  }

  Future<void> _deleteItem(String itemName) async {
  final response = await http.delete(
    Uri.parse('https://boolean-boos.onrender.com/shoppingcart/delete/$itemName/'), // Use the item name in the URL
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // Item deleted successfully, update your UI
    setState(() {
      items.removeWhere((item) => item.name == itemName);
    });
  } else {
    // Handle errors or show a message
  }
}

  void _removeItem(String id, String name) {
    setState(() {
      _deleteItem(name);
      items.removeWhere((item) => item.id == id);
    });
  }

  void _updateItem(String id, String newName, bool isChecked) {
    setState(() {
      var foundItem = items.firstWhere((item) => item.id == id);
      foundItem.name = newName;
      foundItem.isChecked = isChecked;
    });
  }

  @override
  void dispose() {
    _updateCartItems();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.shopping_cart),
                    SizedBox(width: 10),
                    Text(
                      'Shopping List',
                      style: GoogleFonts.phudu(
                          fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                )
              ],
            ),
            Divider(),
            ...items.map((item) {
              final TextEditingController textController = TextEditingController(text: item.name);
              textController.selection = TextSelection.collapsed(offset: item.name.length);
              return Row(
                key: ValueKey(item.id),
                children: <Widget>[
                  Checkbox(
                    value: item.isChecked,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        _updateItem(item.id, item.name, newValue);
                      }
                    },
                    activeColor: Colors.amber,
                  ),
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.amber,
                      controller: textController,
                      onChanged: (newName) => _updateItem(item.id, newName, item.isChecked),
                      decoration: InputDecoration(
                        hintText: 'Enter item name',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () => _removeItem(item.id, item.name),
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
            IntrinsicWidth(
              child: Container(
                height: 40,
                child: ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    primary: Colors.black,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
