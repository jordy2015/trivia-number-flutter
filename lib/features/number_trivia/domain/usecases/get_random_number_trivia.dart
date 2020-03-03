
import 'package:dartz/dartz.dart';
import 'package:test_project/core/error/failures.dart';
import 'package:test_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:test_project/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

class GetRandomNumberTrivia {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> execute() async {
    return await repository.getRandomNumberTrivia();
  }
}