class AppError {
  final String message;

  AppError(this.message) {
    assert(this.message.trim().length > 0);
  }
  AppError.empty() : message = '';

  bool get isEmpty {
    return message.isEmpty;
  }
}
