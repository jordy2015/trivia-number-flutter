
import 'package:dartz/dartz.dart';
import 'package:test_project/core/error/failures.dart';

class Convert {
  Either<Failure, int> stringToInt(String str){
    try {
      return Right(int.parse(str));
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  } 
}