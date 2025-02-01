import 'dart:convert';

import 'package:news_app/models/catogries_news_model.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/categories_news_model.dart';
import '../models/news_channels_headlines_model.dart';

class NewsRepository{
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String name)async{

    String url = 'https://newsapi.org/v2/top-headlines?sources=${name}&apiKey=63a1ea702ec648119a5b534b95b092cd';
    final  response = await http.get(Uri.parse(url)) ;
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }


  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{

    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=63a1ea702ec648119a5b534b95b092cd';
    final  response = await http.get(Uri.parse(url)) ;
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }

}