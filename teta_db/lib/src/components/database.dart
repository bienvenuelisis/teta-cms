part of '../index.dart';

class TetaDB {
  static _TetaDB instance = _TetaDB();
}

class _TetaDB {
  Future<String?> getToken() async {
    final box = await Hive.openBox<dynamic>('supabase_authentication');
    final accessToken =
        ((json.decode(box.get('SUPABASE_PERSIST_SESSION_KEY') as String)
                as Map<String, dynamic>)['currentSession']
            as Map<String, dynamic>)['access_token'] as String;
    final refreshToken =
        ((json.decode(box.get('SUPABASE_PERSIST_SESSION_KEY') as String)
                as Map<String, dynamic>)['currentSession']
            as Map<String, dynamic>)['refresh_token'] as String;
    //SUPABASE_PERSIST_SESSION_KEY
    const url = 'https://auth.teta.so/auth';
    final response = await http.post(
      Uri.parse(url),
      headers: {'content-type': 'application/json'},
      body: json.encode(
        <String, dynamic>{
          'access_token': accessToken,
          'refresh_token': refreshToken,
        },
      ),
    );
    if (response.statusCode == 200) {
      final list = json.decode(response.body) as List<dynamic>;
      final result = list.first as bool;
      final token = list.last as String;
      if (result) {
        return token;
      } else {
        throw Exception('Error putDoc $token');
      }
    } else {
      throw Exception('Error putDoc ${response.statusCode}: ${response.body}');
    }
  }

  /// Create [value] object in collection [collection].
  ///
  /// Returns `true` on success and `false` on failure.
  Future<bool> create(
    final String collection,
    final Map<String, dynamic> value,
  ) async {
    final body = value;

    final uri = Uri.parse('$_baseUrl/db/$collection');

    final res = await http.post(
      uri,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(body),
    );

    return res.statusCode == 200;
  }

  /// Deletes object in document where [path]=[value] on collection [collection].
  ///
  /// Returns `true` on success and `false` on failure.
  Future<bool> delete(
    final String collection, {
    required final String token,
    final String? path,
    final dynamic value,
    final Map<String, dynamic>? rawPath,
  }) async {
    final query =
        rawPath ?? TetaNoSqlUtils.instance.pathToObject('$path', value);

    final body = query;

    final uri = Uri.parse('$_baseUrl/db/$collection');

    final res = await http.delete(
      uri,
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token'
      },
      body: jsonEncode(body),
    );

    debugPrint(res.body);

    return res.statusCode == 200;
  }

  // todo: uwu
  Future<bool> updateDocument(
    final String uid,
    final String docId,
    final Map<String, dynamic> doc, {
    required final String token,
  }) async {
    final uri = Uri.parse('$_baseUrl/cms/doc/$uid/$docId');

    final res = await http.put(
      uri,
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token'
      },
      body: json.encode(doc),
    );

    debugPrint(res.body);

    return res.statusCode == 200;
  }

  /// Adds [content] object in document where [path]=[value] on collection [collection].
  ///
  /// Returns `true` on success and `false` on failure.
  Future<bool> insert(
    final String collection,
    final String path,
    final dynamic value,
    final Map<String, dynamic> content, {
    required final String token,
  }) async {
    final query = TetaNoSqlUtils.instance.pathToObject(path, value);

    final body = {'query': query, 'data': content};

    debugPrint('$body');

    final uri = Uri.parse('$_baseUrl/db/$collection');

    final res = await http.put(
      uri,
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token'
      },
      body: jsonEncode(body),
    );

    debugPrint(res.body);

    return res.statusCode == 200;
  }

  /// Gets documents matching [path] with value [value].
  ///
  /// [path] is composed like this:
  /// COLLECTION.PROP1.PROPn
  ///
  /// ### Tip:
  /// You can use `buildPath` from `TetaNoSqlUtils` to create your path.
  ///
  /// ### Example:
  ///
  /// Object to get on collection `TestCollection`
  /// ```json
  /// {
  ///  "elements": {
  ///     "pages": {
  ///       "primary": { "visits": 0 }
  ///    }
  ///  }
  /// ```
  ///
  /// [path] = `TestCollection.elements.pages.primary.visits`
  ///
  /// [value] = `0`
  ///
  /// Returns `true` on success and `false` on failure.
  Future<dynamic> select(
    final String path,
    final dynamic value, {
    required final String token,
    final String? projection,
    final bool projectionInclusive = false,
    final bool isList = false,
  }) async {
    final arr = path.split('.');

    final collection = arr.first;
    final query = arr.sublist(1).join('.');

    final uri = Uri.parse('$_baseUrl/db/get/$collection');
    final res = await http.post(
      uri,
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
        'query-multiple': '$isList',
      },
      body: json.encode({
        'query': <String, dynamic>{query: value},
        'projection': (projection == null)
            ? {query: 1}
            : {projection: projectionInclusive ? 1 : 0}
      }),
    );

    debugPrint(res.body);

    if (res.statusCode != 200) {
      throw Exception('Request resulted in ${res.statusCode}');
    }

    return json.decode(res.body);
  }
}
