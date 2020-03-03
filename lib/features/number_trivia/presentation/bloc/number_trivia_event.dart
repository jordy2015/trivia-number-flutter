part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {

}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String number;
  GetTriviaForConcreteNumber({@required this.number});
  
  @override
  List get props => [number];
}

class GetTriviaForRandom extends NumberTriviaEvent {
  
  
}
