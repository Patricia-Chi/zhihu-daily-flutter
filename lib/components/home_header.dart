import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String date;

  const HomeHeader({super.key, required this.date});

  // 月份
  String _getMonthName(int month) {
    const months = ["error","一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"];
    return months[month];
  }

  // 问候语
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 3 && hour < 12) return "早上好！";
    if (hour >= 12 && hour < 18) return "下午好！";
    return "晚上好！";
  }

  @override
  Widget build(BuildContext context) {
    // final year = int.parse(date.substring(0,4));
    final month = int.parse(date.substring(4,6));
    final day = int.parse(date.substring(6,8));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("$day",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  )
              ),
              Text(
                _getMonthName(month),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 0.7
                ),
              )
            ],
          ),
          const SizedBox(width: 12),

          // 中间竖线
          Container(
            width: 1,
            height: 35,
            color: Colors.grey.shade300, // 浅灰色
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getGreeting(),
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage('lib/images/avatar.png'),
          ),
        ],
      ),
    );
  }
}