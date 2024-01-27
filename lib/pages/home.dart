import 'package:flutter/material.dart';
import 'package:my_news/models/article_model.dart';
import 'package:my_news/models/category_news.dart';
import 'package:my_news/models/catergory_model.dart';
import 'package:my_news/pages/article_view.dart';
import 'package:my_news/pages/categoryShowNews.dart';
import 'package:my_news/services/data.dart';
import 'package:my_news/services/show_news.dart';
import '../services/news.dart';
class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState()=>_HomeState();
}

class _HomeState extends State<Home>{

  List<CategoryModel> categories = [];
  List<ArticleModel> articles = [];
  // List<categoryNews> categoryArticles = [];
  bool _loading = true;


  @override
  void initState() {
    // TODO: implement initState
    categories = getCategories();
    super.initState();
    getNews();
    // getCategoryNews();
  }


  getNews() async {
    News newClass  = News();
    await newClass.getNews();
    articles = newClass.news;
    setState(() {
      _loading = false;
    });
  }

  // getCategoryNews() async {
  //   showNews newClass  = showNews();
  //   await newClass.getCategoryNews("business");
  //   categoryArticles = newClass.news1;
  //   setState(() {
  //     _loading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter"),
            Text("News",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading ? Center(
          child: Container(
           child: CircularProgressIndicator(),
          )
     ):
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: <Widget>[
          //For Category
          Container(

            height: 70,
            child: ListView.builder(
              shrinkWrap: true,
                ///physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context,index) {
              return CategoryTile(
              image: categories[index].image,
              categoryName: categories[index].categoryName,
            );
          }),
          ),

          ///For Blogs
          Container(
            padding: EdgeInsets.only(top: 16),
            child: ListView.builder(
              shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: articles.length,
                itemBuilder: (context,index){
                  return blogTile(
                      imageurl: articles[index].urltoimage,
                      title: articles[index].title,
                      desc: articles[index].desc,
                      url: articles[index].url,
                  );
                }),
          )
        ],
        ),
      ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget{
  final image , categoryName;
  CategoryTile({this.categoryName,this.image});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){

          Navigator.push(context, MaterialPageRoute(builder:
              (context)=> categoryShowNews(name: categoryName),
          ));

      },
    child: Container(
      margin: EdgeInsets.only(right: 16),

      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
             image ,
              width: 120,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        Container(
          alignment: Alignment.center,
          width: 120,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black38,
          ),

          child: Center(
          child:Text(
          categoryName,
          style:const TextStyle(
          color:Colors.white ,
          fontSize: 14,
          fontWeight:
          FontWeight.bold
          ) ,
          ),
        )
        ),
     ]
       ),
    ),
    );
  }
}

class blogTile extends StatelessWidget{
  final String imageurl , title , desc,url;
  blogTile({required this.imageurl, required this.title, required this.desc,required this.url});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:
        (context)=> ArticleView(
          blogurl: url,
        )
        ));
      },

     child: Container(
      margin: EdgeInsets.only(bottom: 16),
       padding: EdgeInsets.all(10),
       decoration: BoxDecoration(
         border: Border.all(
           color: Colors.black12, // Set the border color
           width: 2.0, // Set the border width
         ),
         borderRadius: BorderRadius.circular(8.0), // Set the border radius
       ),
      child: Column(

      children: <Widget>[
          Row(
          children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(6),
       child: Image.network(
         imageurl,
         width: 100,
         height: 70,
         fit: BoxFit.cover,
       ),
     ),
      SizedBox(width: 16),
      Flexible(
        child: Text(
          title,
          style: TextStyle(

            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ),
      ],
    ),
          //
          // SizedBox(height: 8,),
          //
          // Text(desc,style: TextStyle(
          //   color: Colors.black54
          // ),)
        ],
      ),
    )
    );
  }
}