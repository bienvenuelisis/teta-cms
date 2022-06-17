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

final sl = GetIt.instance;
bool diInitialized = false;

void initGetIt() {
  // 3-rd party libraries
  sl.registerLazySingleton(Dio.new);

  //Data Stores
  sl.registerLazySingleton(ServerRequestMetadataStore.new);

  //Server Response Mappers
  sl.registerLazySingleton(CartMapper.new);
  sl.registerLazySingleton(ProductMapper.new);
  sl.registerLazySingleton(() => ShopMapper(sl(), sl()));

  //Use Cases
  sl.registerLazySingleton(() => GetServerRequestHeaders(sl()));

  // API
  sl.registerLazySingleton(() => TetaStoreCartsApi(sl(), sl(), sl()));
  sl.registerLazySingleton(() => TetaStoreProductsApi(sl(), sl(), sl()));
  sl.registerLazySingleton(() => TetaStore(sl(), sl(), sl()));
}
