import 'package:http/http.dart' as http;

class AppError<T> {
  final T? data;

  AppError(this.data);

  bool get isException => (data is Exception);

  bool get isHttpResponse => (data is http.Response);
}
