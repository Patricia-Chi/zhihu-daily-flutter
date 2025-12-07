import 'package:flutter/material.dart';
import 'package:zhihu_daily/api/zhihu_api.dart';
// 首页组件
import 'package:zhihu_daily/components/home_header.dart';
import 'package:zhihu_daily/components/banner_slider.dart';
import 'package:zhihu_daily/components/news_list.dart';
import 'package:zhihu_daily/components/date_divider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Map<String, dynamic>? latestData; // 存放新闻列表，每加载一天就往里加一项
  List<Map<String, dynamic>> historyList = [];
  String? lastDate;
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();// 滚动控制器，监听是否滑到底部

  @override
  void initState() {
    super.initState();
    loadLatest();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        loadBefore();
      }
    });
  }

  Future<void> loadLatest() async {
    final data = await ZhihuApi.getLatestNews();
    setState(() {
      latestData = data;
      lastDate = data["date"];
    });
  }

  Future<void> loadBefore() async {
    if (isLoadingMore || lastDate == null) return;
    setState(() => isLoadingMore = true);
    final before = await ZhihuApi.getBeforeNews(lastDate!);
    setState(() {
      historyList.add(before);
      lastDate = before["date"];
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (latestData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final banners = latestData!["top_stories"];
    final stories = latestData!["stories"];

    return ListView(
      controller: _scrollController,
      children: [
        // 头部
        HomeHeader(date: latestData!["date"]),
        // 图片滚动栏
        BannerSlider(banners: banners),
        // 今日文章
        NewsList(stories: stories),
        // 以往文章
        ...historyList.map((day) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateDivider(date: day["date"]),
              NewsList(stories: day["stories"]),
            ],
          );
        }).toList(),
        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:zhihu_daily/api/zhihu_api.dart';
import 'package:zhihu_daily/pages/detail_page.dart';

// 首页
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeBody(),
    );
  }
}

// 首页
class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override

  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Map<String, dynamic>? latestData;

  // 之前的数据
  List<Map<String, dynamic>> historyList = [];

  String? lastDate; // 用于 before API
  bool isLoadingMore = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadLatest();

    // 加载历史新闻，滚动到底部
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        loadBefore();
      }
    });
  }

  // 获取今日新闻
  Future<void> loadLatest() async {
    final data = await ZhihuApi.getLatestNews();
    setState(() {
      latestData = data;
      lastDate = data["date"];
    });
  }

  // 获取之前的新闻
  Future<void> loadBefore() async {
    if (isLoadingMore || lastDate == null) return;

    setState(() => isLoadingMore = true);

    final before = await ZhihuApi.getBeforeNews(lastDate!);

    setState(() {
      historyList.add(before);
      lastDate = before["date"];
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (latestData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final banners = latestData!["top_stories"];
    final stories = latestData!["stories"];

    return ListView(
      controller: _scrollController,
      children: [
        // 头部
        _HomeHeader(date: latestData!["date"]),

        // 图片滚动栏
        _BannerSlider(banners: banners),

        // 今日文章
        _NewsList(stories: stories),

        // 以前文章
        ...historyList.map((day) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateDivider(date: day["date"]),
              _NewsList(stories: day["stories"]),
            ],
          );
        }).toList(),

        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}



// appbar

class _HomeHeader extends StatelessWidget {
  final String date;

  const _HomeHeader({super.key, required this.date});

  // 月份
  String _getMonthName(int month) {
    const months = ["error","一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"];
    return months[month];
  }

  // 问候语
  String _getGreeting() {
    final hour = DateTime.now().hour;  // 获取当前时间，如：2025-11-27 16:43:12.123
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
          // const SizedBox(width: 16),
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
          CircleAvatar(// 头像，随便弄的
            radius: 15,
            backgroundImage:
              Image.asset('lib/images/avatar.png').image,
            //NetworkImage("https://i.pravatar.cc/100"),
          ),
        ],
      ),
    );
  }
}


// 分割条
class _DateDivider extends StatelessWidget {
  final String date;

  const _DateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final m = int.parse(date.substring(4, 6));
    final d = int.parse(date.substring(6, 8));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          // 左侧日期
          Text(
            "$m月$d日",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 12),

          // 右侧横线
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




// 图片滚动栏
class _BannerSlider extends StatefulWidget {
  final List<dynamic> banners;

  const _BannerSlider({super.key, required this.banners});

  @override
  State<_BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<_BannerSlider> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.banners.length,
        itemBuilder: (context, index) {
          final item = widget.banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ClipRRect(
              child: Image.network(
                item["image"],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}


/// ------------------------------
/// 新闻列表
/// ------------------------------
class _NewsList extends StatelessWidget {
  final List<dynamic> stories;

  const _NewsList({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: stories.map((news) {
        return _NewsItem(
          title: news["title"],
          hint: news["hint"],
          imageUrl: news["images"][0],
          id: news["id"],
        );
      }).toList(),
    );
  }
}


/// ------------------------------
/// 新闻单个 item
/// ------------------------------
class _NewsItem extends StatelessWidget {
  final String title;
  final String hint;
  final String imageUrl;
  final int id;

  const _NewsItem({
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
          // 点击跳转
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
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    const SizedBox(height: 6),

                    // 作者 + 阅读时长
                    Text(
                      hint,
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
*/