import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_news/models/article_model.dart';
import 'package:my_news/models/catergory_model.dart';
import 'package:my_news/pages/article_view.dart';
import 'package:my_news/pages/categoryShowNews.dart';
import 'package:my_news/services/data.dart';
import '../services/news.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  int activeIndex = 0;


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

        title: Padding(
          padding: const EdgeInsets.only(right: 28),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Flutter"),
              Text("News",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Aditya Patil'), // Replace with actual user name
                accountEmail: Text('adipatil07@gmail.com'),
                // Replace with actual user email
                currentAccountPicture: CircleAvatar(
                  // Replace with an actual user photo
                  backgroundImage: AssetImage('images/adi2.jpg'),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              //  DrawerHeader(
              //   decoration: BoxDecoration(
              //     color: Colors.blue,
              //   ),
              //   child: Text('FlutterNews',style: TextStyle(
              //     fontSize: 20
              //   ),),
              // ),

              ListTile(
                title: const Text('General'),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:
                  (context)=> categoryShowNews(name: "General"),
                  ));
                },
              ),

            ListTile(
              title: const Text('Health'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=> categoryShowNews(name: "Health"),
                ));
              },
            ),

            ListTile(
              title: const Text('Business'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=> categoryShowNews(name: "business"),
                ));
              },
            ),

            ListTile(
              title: const Text('Entertainment'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=> categoryShowNews(name: "Entertainment"),
                ));
              },
            ),

            ListTile(
              title: const Text('Sports'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=> categoryShowNews(name: "Sports"),
                ));
              },
            ),

            ListTile(
              title: const Text('Science'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=> categoryShowNews(name: "Science"),
                ));
              },
            ),
        ]
        ),
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

          //Breaking News Text
          Container(
            padding: EdgeInsets.all(12),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Icon(Icons.warning, color: Colors.black), // Example of using an icon
                Text(
                  "Breaking News !",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,

                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          //For SLider
          CarouselSlider.builder(
              itemCount: articles.length > 5 ? 5 : articles.length,
                  itemBuilder: (context,index, realindex){
                    final url = articles[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:
                            (context)=> ArticleView(
                          blogurl: articles[index].url,
                        )
                        ));
                      },
                        child: buildImages(url,index)
                    );

                  },
                  options: CarouselOptions(
                      height: 250,
                      autoPlay: true,
                    enlargeCenterPage: true,
                    initialPage: 1,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index , reason ){
                        setState(() {
                          activeIndex = index;
                        });
                    },
                  )
              ),
            SizedBox(height: 10,),
            buildIndicator(),

          SizedBox(height: 20,),
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

  Widget buildImages(ArticleModel article, int index) => Container(
    margin: EdgeInsets.symmetric(horizontal: 12),

    child: Stack(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              article.urltoimage,
              fit: BoxFit.cover,
              height: 250,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          height: 250,
          margin: EdgeInsets.only(top: 170),
          decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))),
          child:Text(
            article.title, // Assuming 'title' is the property in your ArticleModel class
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )

        // SizedBox(height: 8), // Adjust the spacing between image and heading

      ],
    ),
  );

      Widget buildIndicator()=> AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count : 5
      );

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
              FontWeight.bold,
                
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