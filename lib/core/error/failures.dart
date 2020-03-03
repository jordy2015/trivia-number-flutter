
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List propierties = const <dynamic>[]]) : super(propierties);
}

class ServerFailure extends Failure { }

class CacheFailure extends Failure { }

class InvalidInputFailure extends Failure { }



