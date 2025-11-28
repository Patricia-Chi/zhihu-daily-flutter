import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zhihu_daily/api/zhihu_api.dart';

class NewsDetailPage extends StatefulWidget {
  final int id;

  const NewsDetailPage({super.key, required this.id});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  Map<String, dynamic>? detail;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    final res = await Dio().get(
      "https://news-at.zhihu.com/api/4/news/${widget.id}",
    );
    setState(() {
      detail = res.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (detail == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(detail!["title"] ?? "详情"),
      ),
      body: SingleChildScrollView(
        //padding: const EdgeInsets.all(16),
        child: Html(
            data: detail!["body"],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          //home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ''
                'Comments',
          ),
          //profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Likes',
          ),
          //settings
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Star',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}
