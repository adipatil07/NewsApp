import 'package:flutter/material.dart';
import '../models/category_news.dart';
import '../services/show_news.dart';
import 'article_view.dart';
import 'home.dart';

class categoryShowNews extends StatefulWidget {
  final String name;

  categoryShowNews({required this.name});

  @override
  _categoryShowNewsState createState() => _categoryShowNewsState();
}

class _categoryShowNewsState extends State<categoryShowNews> {
  List<categoryNews> categoryArticles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoryNews();
  }

  Future<void> fetchCategoryNews() async {
    showNews newClass = showNews();
    await newClass.getCategoryNews(widget.name);

    setState(() {
      categoryArticles = newClass.news1;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
        padding: EdgeInsets.only(top: 16),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: categoryArticles.length,
          itemBuilder: (context, index) {
            return blogTile(
              imageurl: categoryArticles[index].urltoimage,
              title: categoryArticles[index].title,
              desc: categoryArticles[index].desc,
              url: categoryArticles[index].url,
            );
          },
        ),
      ),
    );
  }
}

class blogTile extends StatelessWidget {
  final String imageurl, title, desc, url;

  blogTile({
    required this.imageurl,
    required this.title,
    required this.desc,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(
              blogurl: url,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16,right: 15,left: 15),

        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12, // Set the border color
            width: 2.0, // Set the border width
          ),
          borderRadius: BorderRadius.circular(8.0), // Set the border radius
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(imageurl),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 17, color: Colors.black87),
            ),
            SizedBox(height: 8,),
            Text(
              desc,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
