import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        width: double.infinity,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const Divider(color: Colors.grey), // Header와 Body를 구분
            _body(),
            const Spacer(),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "메모",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.more_vert, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _body() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "내용",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _footer() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.label, color: Colors.grey),
              SizedBox(width: 5),
              Text(
                "태그",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Icon(Icons.copy, color: Colors.grey),
        ],
      ),
    );
  }
}
