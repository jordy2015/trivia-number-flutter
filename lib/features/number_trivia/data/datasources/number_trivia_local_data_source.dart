import 'dart:convert';
import 'package:test_project/core/error/exceptions.dart';
import 'package:test_project/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const TRIVIA_CACHE_KEY = 'CACHE_NUMBER_TRIVIA_KEY';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache); 
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(TRIVIA_CACHE_KEY, json.encode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(TRIVIA_CACHE_KEY);
    if(jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}