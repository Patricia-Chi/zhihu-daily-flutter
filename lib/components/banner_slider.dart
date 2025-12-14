import 'package:flutter/material.dart';
import 'package:zhihu_daily/pages/detail_page.dart'; // 导入详情页以便跳转

class BannerSlider extends StatefulWidget {
  final List<dynamic> banners;

  const BannerSlider({super.key, required this.banners});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0; // 记录当前显示的图片

  @override
  void dispose() {
    _controller.dispose(); // 销毁组件时释放控制器，防止内存泄漏
    super.dispose();
  }

  // 解析颜色字符串
  // 默认黑色
  Color _parseColor(String? colorStr) {
    if (colorStr == null || !colorStr.startsWith("0x")) {
      return Colors.black;
    }
    try {
      // 去掉0x
      final hex = colorStr.substring(2);
      final value = int.parse(hex, radix: 16);
      return Color(value | 0xFF000000);
    } catch (e) {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Stack(
        children: [
          // PageView 图片
          PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            // 监听滚动
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final item = widget.banners[index];
              final hueColor = _parseColor(item["image_hue"]);

              return GestureDetector(
                onTap: () {
                  // 详情页
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailPage(id: item["id"]),
                    ),
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 底层图片
                    Image.network(
                      item["image"],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey),
                    ),

                    // 渐变遮罩
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 150, // 渐变高度，可调整
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              hueColor.withOpacity(1), // 底部颜色
                              hueColor.withOpacity(0.0), // 顶部透明
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 标题
                    Positioned(
                      bottom: 30,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item["title"] ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item["hint"] ?? "",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // 指示器
          Positioned(
            bottom: 10,
            right: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.banners.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/*import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  final List<dynamic> banners;

  const BannerSlider({super.key, required this.banners});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
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
            child: Image.network(item["image"], fit: BoxFit.cover),// 加载图片
          );
        },
      ),
    );
  }
}
*/
