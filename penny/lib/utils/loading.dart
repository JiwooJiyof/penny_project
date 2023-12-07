import 'dart:async';
import 'package:flutter/material.dart';

class MovingCartAnimation extends StatefulWidget {
  @override
  _MovingCartAnimationState createState() => _MovingCartAnimationState();
}

class _MovingCartAnimationState extends State<MovingCartAnimation> {
  int cartPosition = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 150), (Timer t) {
      setState(() {
        cartPosition = (cartPosition + 1) % 5; // 5 positions
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // cancel a timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = List.generate(5, (index) {
      if (index == cartPosition) {
        // The position of the cart
        return Icon(
          Icons.shopping_cart_outlined,
          size: 40,
          color: Colors.amber,
        );
      } else {
        // Empty positions represented by dots
        return Icon(
          Icons.circle,
          size: 15,
          color: Colors.amber,
        );
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: rowChildren,
    );
  }
}
