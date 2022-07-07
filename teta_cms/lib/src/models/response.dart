import 'package:teta_cms/src/models/store/cart.dart';
import 'package:teta_cms/src/models/store/product.dart';

class TetaResponse<DATA, ERROR> {
  TetaResponse({
    required this.data,
    required this.error,
  });

  final DATA data;
  final ERROR error;
}

class TetaErrorResponse {
  TetaErrorResponse({
    this.message,
    this.code,
  });

  final String? message;
  final int? code;
}

class TetaProductResponse
    extends TetaResponse<TetaProduct?, TetaErrorResponse?> {
  TetaProductResponse({
    final TetaProduct? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaProductsResponse
    extends TetaResponse<List<TetaProduct>?, TetaErrorResponse?> {
  TetaProductsResponse({
    final List<TetaProduct>? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaCartResponse extends TetaResponse<TetaCart?, TetaErrorResponse?> {
  TetaCartResponse({
    final TetaCart? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}

class TetaPaymentIntentResponse
    extends TetaResponse<String?, TetaErrorResponse?> {
  TetaPaymentIntentResponse({
    final String? data,
    final TetaErrorResponse? error,
  }) : super(data: data, error: error);
}
