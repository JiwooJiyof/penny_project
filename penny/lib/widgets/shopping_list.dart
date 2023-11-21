import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List<ShoppingCartItem> items = [
    ShoppingCartItem(id: Uuid().v4())
  ]; // Start with one empty item

  void _addItem() {
    setState(() {
      items.add(ShoppingCartItem(
          id: Uuid().v4())); // Add a new item at the end of the list
    });
  }

  void _removeItem(String id) {
    setState(() {
      items.removeWhere((item) => item.id == id); // Remove item with given id
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
                      controller: TextEditingController(text: item.name)
                        ..selection =
                            TextSelection.collapsed(offset: item.name.length),
                      onChanged: (newName) =>
                          _updateItem(item.id, newName, item.isChecked),
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
                    onPressed: () => _removeItem(item.id),
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
            IntrinsicWidth(
              child: Container(
                height: 40, // Adjust the height as needed
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
