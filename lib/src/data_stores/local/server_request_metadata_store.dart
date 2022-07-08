import 'package:teta_cms/src/models/server_request_metadata.dart';

/// Request the store metadata
class ServerRequestMetadataStore {
  ServerRequestMetadata _localMetadata = ServerRequestMetadata(
    token: 'default',
    prjId: 0,
  );

  /// Get metadata
  ServerRequestMetadata getMetadata() => _localMetadata;

  /// Update metadata
  ServerRequestMetadata updateMetadata({
    final String? token,
    final int? prjId,
  }) {
    _localMetadata = _localMetadata.copyWith(token: token, prjId: prjId);

    return getMetadata();
  }
}
