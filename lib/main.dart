import 'package:flutter/material.dart';
import 'package:news_app/NewsListPage.dart';
import 'package:news_app/model/Categories.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red[800],
        accentColor: Colors.red[300],
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Categories> categoriesList;

  @override
  void initState() {
    categoriesList = <Categories>[];
    categoriesList = loadCategories();
    super.initState();
  }

  List<Categories> loadCategories() {
    var categories = <Categories>[
      //adding all the categories of news in the list
      Categories('assets/images/top_news_new.png', "Top Headlines", "top_news"),
      Categories('assets/images/health_news.png', "Health", "health"),
      Categories('assets/images/entertainment_news.png', "Entertainment",
          "entertainment"),
      Categories('assets/images/sports_news.png', "Sports", "sports"),
      Categories('assets/images/business_news_new.png', "Business", "business"),
      Categories('assets/images/tech_news.png', "Technology", "technology"),
      Categories('assets/images/science_news.png', "Science", "science"),
      Categories('assets/images/politics_news.png', "Politics", "politics")
    ];
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    const title = 'News Categories';
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.teal.shade200, Colors.red.shade400])),
        child: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this would produce 2 rows.
          crossAxisCount: 2,
          // Generate 100 Widgets that display their index in the List
          children: List.generate(categoriesList.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  elevation: 15.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      categoriesList[index].image ?? '',
                      height: 80.0,
                      width: 80.0,
                    ),
                    Text(
                      categoriesList[index].title ?? '',
                      style:
                          const TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => NewsListPage(
                          categoriesList[index].title ?? '',
                          categoriesList[index].newsType ?? '')));
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
