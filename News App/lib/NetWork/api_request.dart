
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:news_app/Const/Const.dart';
import 'package:news_app/Model/news.dart';
import 'package:http/http.dart' as http;

News parseNews(String responseBody){
  var data = json.decode(responseBody);
  var news = News.fromJson(data);
  return news;
}


Future<News> fetchNewsByCategory(String category) async{
  final http.Response response = await http.get(Uri.parse('.....................................................................'));
  if(response.statusCode == 200)
    return compute(parseNews , response.body);
  else if(response.statusCode == 200)
    throw Exception("Not found 404");
  else
    throw Exception("Can't get News");
}