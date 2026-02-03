import 'dart:io';
import 'dart:math';

import 'package:clean_architecture_app/core/constants/constants.dart';
import 'package:clean_architecture_app/core/resources/data_state.dart';
import 'package:clean_architecture_app/features/daily_news/data/models/article.dart';
import 'package:clean_architecture_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:dio/dio.dart';

import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;

  ArticleRepositoryImpl(this._newsApiService);
  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
          country, newsAPIKey, categoryQuery);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(data: httpResponse.data);
      } else {
        return DataFailed(DioError(
          requestOptions: httpResponse.response.requestOptions,
          response: httpResponse.response,
          type: DioErrorType.badResponse,
          error: httpResponse.response.statusMessage,
        ));
      }
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }
}
