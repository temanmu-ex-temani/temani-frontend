import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../services/logger_service.dart';

Future<http.Response> postHttp(
  String url, {
  Map<String, dynamic>? body,
  Map<String, String>? headers,
}) async {
  final resp = await http.post(
    Uri.parse(url),
    headers: headers ??
        <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
    body: jsonEncode(body),
  );
  if (kDebugMode) {
    LoggerService.i(
      {
        'response': resp.body,
        'statusCode': resp.statusCode,
      },
    );
  }
  return resp;
}
