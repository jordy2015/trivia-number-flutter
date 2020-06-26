import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:test_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:test_project/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:test_project/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  @override
  NumberTriviaState get initialState => Empty();

  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
  })  : assert(concrete != null),
        assert(random != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      yield Loading();
      final failureOrTrivia = await getConcreteNumberTrivia.execute(
          number: int.parse(event.number));
      yield failureOrTrivia.fold(
          (failure) => throw Error(message: "Server Fail"),
          (trivia) => Loaded(trivia: trivia));
    } else if (event is GetTriviaForRandom) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia.execute();
      yield failureOrTrivia.fold((failure) => Error(message: "random failt"),
          (trivia) => Loaded(trivia: trivia));
    }
    // TODO: implement mapEventToState
  }
}
