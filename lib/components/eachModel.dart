// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_const_constructors, file_names

import 'package:flutter/material.dart';

class EachModel extends StatefulWidget {
  const EachModel({
    super.key,
    required this.image,
    required this.name,
    required this.detail,
  });

  final String image;
  final String name;
  final String detail;

  @override
  State<EachModel> createState() => _EachModelState();
}

class _EachModelState extends State<EachModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      padding: EdgeInsets.only(left: 8.0, top: 7.0, bottom: 7.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.image,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        widget.detail,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
}
