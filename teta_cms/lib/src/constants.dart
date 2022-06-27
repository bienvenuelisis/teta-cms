class Constants {
  static const String docId = '_id';
  static const String prjIdKey = 'prj_id';

  static const String _host = 'public.teta.so';
  static const String _port = '9840';
  static const String tetaUrl = 'https://$_host:$_port';
  static const Map<String, String> defaultHeaders = <String, String>{
    'Content-Type': 'application/json',
  };
}
