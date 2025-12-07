import 'package:flutter/material.dart';

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
