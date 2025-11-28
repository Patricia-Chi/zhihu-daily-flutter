import 'package:dio/dio.dart';

class ZhihuApi {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://news-at.zhihu.com/api/4/news/"),
  );

  /// 今日热闻
  static Future<Map<String, dynamic>> getLatestNews() async {
    final res = await _dio.get("latest");
    return res.data;
  }

  /// 获取某一天之前的新闻
  /// 注意：传入 20230425 得到 20230424 的内容
  static Future<Map<String, dynamic>> getBeforeNews(String date) async {
    final res = await _dio.get("before/$date");
    return res.data;
  }
}
