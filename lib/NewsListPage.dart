import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/NewsDetails.dart';
import 'package:news_app/Strings.dart';
import 'package:news_app/model/News.dart';

class NewsListPage extends StatefulWidget {
  final String title;
  final String newsType;

  NewsListPage(this.title, this.newsType);

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  Future<List<Article>> getData(String newsType) async {
    late List<Article> list;

    var key = Strings.apiKey;
    var country = Strings.country;
    String link = "";

    // ignore: unrelated_type_equality_checks
    if (newsType == "top_news") {
      link =
          "https://newsapi.org/v2/top-headlines?country=$country&apiKey=$key";
    } else {
      link =
          "https://newsapi.org/v2/top-headlines?country=$country&category=$newsType&apiKey=$key";
    }
    var res = await http
        .get(Uri.parse(link), headers: {"Accept": "application/json"});
    if (kDebugMode) {
      print(res.body);
    }
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["articles"] as List;
      if (kDebugMode) {
        print(rest);
      }
      list = rest.map<Article>((json) => Article.fromJson(json)).toList();
    }
    if (kDebugMode) {
      print("List Size: ${list.length}");
    }
    return list;
  }

  Widget listViewWidget(List<Article> article) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.teal.shade200, Colors.red.shade400])),
      child: ListView.builder(
          itemCount: article.length,
          itemBuilder: (context, position) {
            return Card(
              color: Colors.white10,
              elevation: 3.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              child: InkWell(
                onTap: () {
                  onTapItem(context, article[position]);
                },
                child: Column(
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                        placeholder: 'assets/images/processing.gif',
                        image:article[position].urlToImage ?? '',
                        fit: BoxFit.cover, height: 220.0, width: double.infinity
                    ),
                    Text(
                      article[position].title ?? '',
                      style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: getData(widget.newsType),
          builder: (context, snapshot) {
            if( snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else{
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return listViewWidget(snapshot.data!);
              }
            }
          }),
    );
  }

  void onTapItem(BuildContext context, Article article) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => NewsDetails(article, widget.title)));
  }
}
