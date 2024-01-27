import 'dart:convert';

import '../models/article_model.dart';
import 'package:http/http.dart' as http;
class News{
  List<ArticleModel> news = [];
  Future<void> getNews() async{
    String url = "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=e025c635c7f1480da02ae9c01fd8947a";
    var uri = Uri.parse(url);
    var response = await http.get(uri);

    var jsonData  = jsonDecode(response.body);

    if(jsonData["status"]=="ok"){
      jsonData["articles"].forEach((element){
        if (element["urlToImage"] != null && element["description"] != null) {

          ArticleModel articleModel = ArticleModel(
            title: element["title"] ?? "",
            author: element["author"] ?? "",
            desc: element["description"] ?? "",
            content: element["content"] ?? "",
            url: element["url"] ?? "",
            urltoimage: element["urlToImage"],
          );

          news.add(articleModel);
        }
      });
    }
}

}