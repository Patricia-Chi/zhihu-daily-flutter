import 'package:flutter/material.dart';

class DateDivider extends StatelessWidget {
  final String date;

  const DateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final m = int.parse(date.substring(4, 6));
    final d = int.parse(date.substring(6, 8));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Text(
            "$m月$d日",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}