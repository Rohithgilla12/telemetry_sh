import 'dart:convert';

import 'package:http/http.dart' as http;

/// {@template telemetry_sh}
/// A simple telemetry logging SDK for Dart
/// {@endtemplate}
class TelemetrySh {
  /// {@macro telemetry_sh}
  TelemetrySh(
    String apiKey, {
    http.Client? client,
  })  : _apiKey = apiKey,
        _client = client ?? http.Client();

  final String? _apiKey;
  final http.Client _client;
  final String _baseUrl = 'https://api.telemetry.sh';

  /// Log data to a specific table
  ///
  /// [table] is the name of the table to log data to.
  /// [data] is a map containing the data to be logged.
  /// [options] is an optional map of additional parameters for the log request.
  ///
  /// Returns a [Future] that completes with a [Map] containing
  /// the response from the server.
  ///
  /// Throws an [Exception] if the API request fails or returns an error.
  /// Example:
  ///
  /// ```dart
  /// await telemetry.log('users', {
  ///  'name': 'John Doe',
  ///  'email': 'john.doe@test.com'
  /// });
  /// ```
  ///
  Future<Map<String, dynamic>> log(
    String table,
    Map<String, dynamic> data, {
    Map<String, dynamic> options = const {},
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _apiKey!,
    };

    final body = {
      'data': data,
      'table': table,
      ...options,
    };

    final response = await _client.post(
      Uri.parse('$_baseUrl/log'),
      headers: headers,
      body: jsonEncode(body),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Query the telemetry data
  ///
  /// [query] is the SQL query string to execute.
  /// [options] is an optional map of additional query parameters.
  ///
  /// Returns a [Future] that completes with a [Map] containing
  ///  the query results.
  ///
  /// Throws an [Exception] if the API request fails or returns an error.
  /// Example:
  ///
  /// ```dart
  /// await telemetry.query('SELECT * FROM users');
  /// ```
  Future<Map<String, dynamic>> query(
    String query, {
    Map<String, dynamic> options = const {},
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _apiKey!,
    };

    final body = {
      'query': query,
      'realtime': true,
      'json': true,
      ...options,
    };

    final response = await _client.post(
      Uri.parse('$_baseUrl/query'),
      headers: headers,
      body: jsonEncode(body),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
