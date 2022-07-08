import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';
import 'package:teta_cms/src/mappers/cart_mapper.dart';
import 'package:teta_cms/src/mappers/product_mapper.dart';
import 'package:teta_cms/src/mappers/shop_mapper.dart';
import 'package:teta_cms/src/store.dart';
import 'package:teta_cms/src/store/carts_api.dart';
import 'package:teta_cms/src/store/products_api.dart';
import 'package:teta_cms/src/use_cases/get_server_request_headers/get_server_request_headers.dart';

/// Instance
final sl = GetIt.instance;

/// Flag is initialized
bool diInitialized = false;

/// Initialize GetIt
void initGetIt() {
  // 3-rd party libraries
  sl
    ..registerLazySingleton(Dio.new)

    //Data Stores
    ..registerLazySingleton(ServerRequestMetadataStore.new)

    //Server Response Mappers
    ..registerLazySingleton(CartMapper.new)
    ..registerLazySingleton(ProductMapper.new)
    ..registerLazySingleton(() => ShopMapper(sl(), sl()))

    //Use Cases
    ..registerLazySingleton(() => GetServerRequestHeaders(sl()))

    // API
    ..registerLazySingleton(() => TetaStoreCartsApi(sl(), sl(), sl()))
    ..registerLazySingleton(() => TetaStoreProductsApi(sl(), sl(), sl()))
    ..registerLazySingleton(() => TetaStore(sl(), sl(), sl()));
}
