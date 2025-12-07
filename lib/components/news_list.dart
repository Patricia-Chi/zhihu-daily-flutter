import 'package:flutter/material.dart';
import 'package:zhihu_daily/pages/detail_page.dart';

class NewsList extends StatelessWidget {
  final List<dynamic> stories;

  const NewsList({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: stories.map((news) {
        return NewsItem(
          title: news["title"],
          hint: news["hint"],
          imageUrl: news["images"][0],
          id: news["id"],
        );
      }).toList(),
    );
  }
}

class NewsItem extends StatelessWidget {
  final String title;
  final String hint;
  final String imageUrl;
  final int id;

  const NewsItem({
    super.key,
    required this.title,
    required this.hint,
    required this.imageUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetailPage(id: id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // 新闻标题
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hint, // 作者
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            ClipRRect(
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}