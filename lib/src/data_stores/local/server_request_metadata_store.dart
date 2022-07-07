import 'package:teta_cms/src/models/server_request_metadata.dart';

class ServerRequestMetadataStore {
  ServerRequestMetadata _localMetadata = ServerRequestMetadata(
    token: 'default',
    prjId: 0,
  );

  ServerRequestMetadata getMetadata() => _localMetadata;

  ServerRequestMetadata updateMetadata({
    final String? token,
    final int? prjId,
  }) {
    _localMetadata = _localMetadata.copyWith(token: token, prjId: prjId);

    return getMetadata();
  }
}
