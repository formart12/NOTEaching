import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: const TextField(
          decoration: InputDecoration(
              hintText: "검색어를 입력하세요.",
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                size: 35,
              )),
        ),
      ),
    );
  }
}
