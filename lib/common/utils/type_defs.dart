import 'package:fpdart/fpdart.dart';
import 'package:todo_main/common/utils/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
