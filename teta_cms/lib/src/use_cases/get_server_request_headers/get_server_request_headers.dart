import 'package:teta_cms/src/data_stores/local/server_request_metadata_store.dart';

class GetServerRequestHeaders {
  GetServerRequestHeaders(this.metadataStore);

  final ServerRequestMetadataStore metadataStore;
  Map<String, String> execute() {
    final metadata = metadataStore.getMetadata();

    return <String, String>{
      'authorization': 'Bearer ${metadata.token}',
      'x-teta-prj-id': metadata.prjId.toString(),
      'content-type': 'application/json'
    };
  }
}
