import 'package:news_app/models/catogries_news_model.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

import '../models/categories_news_model.dart';

class NewsViewModel{

  final _rep =  NewsRepository();
  Future<NewsChannelsHeadlinesModel>  fetchNewsChannelHeadlinesApi(String name)async{
    final response = await _rep.fetchNewsChannelsHeadlinesApi(name);
    return response;
  }

  Future<CategoriesNewsModel>  fetchCategoriesNewsApi(String category)async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }

}