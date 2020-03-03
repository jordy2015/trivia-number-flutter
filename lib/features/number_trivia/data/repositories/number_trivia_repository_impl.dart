import 'package:dartz/dartz.dart';
import 'package:test_project/core/error/exceptions.dart';
import 'package:test_project/core/error/failures.dart';
import 'package:test_project/core/network/network_info.dart';
import 'package:test_project/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:test_project/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:test_project/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:test_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:test_project/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter/cupertino.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviaRespositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRespositoryImpl({
    @required this.remoteDataSource, 
    @required this.localDataSource, 
    @required this.networkInfo
  });
  
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    return await _getTrivia((){
      return remoteDataSource.getConcreteNumberTrivia(number);
      });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia((){
      return remoteDataSource.getRandomNumberTrivia();
      });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(_ConcreteOrRandomChooser function) async {
     if (await networkInfo.isConnected) {
      try {
        NumberTriviaModel result = await function();
        localDataSource.cacheNumberTrivia(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      } 
    } else {
      try {
        final result = await localDataSource.getLastNumberTrivia();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}