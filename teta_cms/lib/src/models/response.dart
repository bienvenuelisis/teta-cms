class TetaResponse {
  TetaResponse({
    this.data,
    this.error,
  });

  final dynamic data;
  final dynamic error;
}

class TetaErrorResponse {
  TetaErrorResponse({
    this.message,
    this.code,
  });

  final String? message;
  final int? code;
}
