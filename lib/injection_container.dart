import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/core/network/network_info.dart';
import 'package:test_project/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:test_project/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:test_project/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:test_project/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:test_project/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:test_project/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:test_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final di = GetIt.instance;

Future<void> init() async {
  //feature - Number Trivia
  // Bloc
  di.registerFactory(() => NumberTriviaBloc(concrete: di(), random: di()));
  //use cases
  di.registerLazySingleton(() => GetConcreteNumberTrivia(di()));
  di.registerLazySingleton(() => GetRandomNumberTrivia(di()));

  //repository
  di.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRespositoryImpl(
          localDataSource: di(), remoteDataSource: di(), networkInfo: di()));

  //DataSource
  di.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(dio: di()));
  di.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: di()));

  //core
  di.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: di()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => sharedPreferences);
  di.registerLazySingleton(() => Dio());
  di.registerLazySingleton(() => DataConnectionChecker());
}
