part of '_client.dart';

Future<Either<Failure, T>> apiCall<T>(Future<T> t) async {
  try {
    final futureCall = await t;
    return Right(futureCall);
  } on SocketException {
    return Left(Failure(message: 'No Internet Connection'));
  } on DioException catch (e) {
    LoggerService.f(e.runtimeType);
    LoggerService.f(parseDioError(e));
    return Left(Failure(message: parseDioError(e)));
  } catch (e) {
    LoggerService.f(e.runtimeType);
    LoggerService.f(e.toString());
    return Left(Failure(message: e.toString()));
  }
}

String parseDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.cancel:
      return 'Request to API server was cancelled';
    case DioExceptionType.receiveTimeout:
      return 'Receive timeout in connection with API server';
    case DioExceptionType.sendTimeout:
      return 'Send timeout in connection with API server';
    case DioExceptionType.connectionTimeout:
      return 'Connection to API server timed out';
    case DioExceptionType.badCertificate:
      return 'Invalid SSL certificate';
    case DioExceptionType.badResponse:
      return 'Received invalid response from API server';
    case DioExceptionType.connectionError:
      return 'Error connecting to API server';
    case DioExceptionType.unknown:
      return 'Unknown error occurred';
  }
}
