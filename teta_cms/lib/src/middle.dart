/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teta_cms/src/constants.dart';

class TetaMiddleAPI {
  /// Singleton
  static _TetaDB instance = _TetaDB();
}

class _TetaDB {
  Future<dynamic> getDocsById({
    required final String collection,
    required final String id,
  }) async {
    final url = '${Constants.tetaUrl}/db/$collection/$id';
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error fetching a the collection: $collection');
    }
  }

  Future<List<dynamic>> getDocsByQuery({
    required final String collection,
    required final Map<String, dynamic> query,
    final Map<String, dynamic> projection = const <String, dynamic>{},
  }) async {
    final url = '${Constants.tetaUrl}/db/get/$collection';
    final response = await http.post(
      Uri.parse(url),
      headers: Constants.defaultHeaders,
      body: json.encode(
        <String, dynamic>{
          'query': query,
          'projection': projection,
        },
      ),
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception(
        'Error fetching the collection: $collection, code: ${response.statusCode}, body: ${response.body}',
      );
    }
  }

  /// :collection BODY {"name":"antonio", anni: 12}
  Future insertDoc({
    required final String collection,
    required final Map<String, dynamic> attributes,
  }) async {
    final url = '${Constants.tetaUrl}/db/$collection';
    final response = await http.post(
      Uri.parse(url),
      headers: Constants.defaultHeaders,
      body: json.encode(attributes),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Error in insertDoc: ${response.statusCode}: ${response.body}',
      );
    }
  }

  Future putDoc({
    required final String collection,
    required final Map<String, dynamic> query,
    required final Map<String, dynamic> data,
  }) async {
    final url = '${Constants.tetaUrl}/db/$collection';
    final response = await http.put(
      Uri.parse(url),
      headers: Constants.defaultHeaders,
      body: json.encode(
        <String, dynamic>{
          'query': query,
          'data': data,
        },
      ),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error putDoc ${response.statusCode}: ${response.body}');
    }
  }

  Future deleteDocById({
    required final String collection,
    required final String id,
  }) async {
    final url = '${Constants.tetaUrl}/db/$collection/$id';
    final response = await http.delete(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error putDoc ${response.statusCode}: ${response.body}');
    }
  }

  Future deleteDocByQuery({
    required final String collection,
    required final Map<String, dynamic> query,
  }) async {
    final url = '${Constants.tetaUrl}/db/$collection';
    final response = await http.delete(
      Uri.parse(url),
      headers: Constants.defaultHeaders,
      body: json.encode(
        query,
      ),
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return json.decode(response.body);
    } else {
      throw Exception(
        'Error deleteDocByQuery ${response.statusCode}: ${response.body}',
      );
    }
  }
}
*/