import 'package:flutter/material.dart';

class SelectPageItemWidget extends StatelessWidget {
  final String string;
  final bool highlight;

  const SelectPageItemWidget({
    required this.string,
    required this.highlight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: highlight ? Colors.pink : Colors.grey, borderRadius: BorderRadius.circular(8)),
      child: Text(
        string,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: highlight ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}