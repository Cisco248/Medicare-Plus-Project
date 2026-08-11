import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchController = TextEditingController();
  bool onText = false;

  @override
  void initState() {
    searchController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 16),
      height: 40,
      child: Stack(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search for medicine',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: 40,
              height: 40,
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsetsGeometry.symmetric(horizontal: 0, vertical: 0),
                  ),
                ),
                child: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
