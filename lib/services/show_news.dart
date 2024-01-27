import 'dart:convert';
import 'package:my_news/models/category_news.dart';
import 'package:http/http.dart' as http;

class showNews {
  List<categoryNews> news1 = [];
  String? categoryName;

  // Pass the category name as a parameter
  Future<void> getCategoryNews(String categoryName) async {
    this.categoryName = categoryName; // Set the category name
    String apiKey = "e025c635c7f1480da02ae9c01fd8947a";
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=$categoryName&apiKey=$apiKey";
    var uri = Uri.parse(url);

    var response = await http.get(uri);

    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          categoryNews articleModel = categoryNews(
            title: element["title"] ?? "",
            author: element["author"] ?? "",
            desc: element["description"] ?? "",
            content: element["content"] ?? "",
            url: element["url"] ?? "",
            urltoimage: element["urlToImage"],
          );

          news1.add(articleModel);
        }
      });
    }
  }
}
