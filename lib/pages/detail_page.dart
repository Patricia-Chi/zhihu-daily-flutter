import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_html/flutter_html.dart';

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
      /*appBar: AppBar(

        // title: Text(detail!["title"] ?? "详情"),
        // automaticallyImplyLeading: false,
      ),*/
      body: SingleChildScrollView(
        //padding: const EdgeInsets.all(16),
        child: Html(
            data: detail!["body"],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 设置选中和未选中项的颜色都为黑色
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        // 强制显示所有图标和标签
        type: BottomNavigationBarType.fixed,
        // 图标字符
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          // 返回
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: [
          // 返回
          const BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
          // 评论
          BottomNavigationBarItem(
            icon: Row(
              mainAxisSize: MainAxisSize.min, // 紧凑布局
              children: [
                const Icon(Icons.comment),
                const SizedBox(width: 4),
                // 评论数
                /*Text(
                  "${detail!['comments'] ?? 0}",
                  style: const TextStyle(color: Colors.black),
                ),*/
              ],
            ),
            label: 'Comments',
          ),
          // 点赞
          BottomNavigationBarItem(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.thumb_up),
                const SizedBox(width: 4),
                // 点赞数
                /*Text(
                  "${detail!['popularity'] ?? 0}",
                  style: const TextStyle(color: Colors.black),
                ),*/
              ],
            ),
            label: 'Likes',
          ),
          // 收藏
          const BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Star',
          ),
          // 分享
          const BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Share',
          ),
        ],
      ),
    );
  }
}
