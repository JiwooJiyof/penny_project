import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const Search({
    Key? key,
    required this.controller,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        controller: controller,
        cursorColor: Colors.amber,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: () => onSearch(controller.text),
            child: Icon(Icons.search, color: Colors.amber),
          ),
          hintText: 'Search for a product...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
        onSubmitted: (value) => onSearch(value),
      ),
    );
  }
}
