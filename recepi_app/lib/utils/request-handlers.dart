import 'dart:convert';

import 'package:http/http.dart' as http;

//the following are async methods which handl all the basic CRUD operations
Future<http.Response> handleGetRequest(
    {String baseUrl,
    String modelPath,
    String exactPath = "",
    Map<String, String> filter}) async {
  var url = Uri.http(baseUrl, "$modelPath/$exactPath", filter);
  return http.get(url);
}

Future<http.Response> handlePostRequest(
    {String baseUrl,
    String modelPath,
    String exactPath = "",
    dynamic body,
    Map<String, String> headers,
    Map<String, String> filter}) async {
  var url = Uri.http(baseUrl, "$modelPath/$exactPath", filter);
  return http.post(url, body: body, headers: headers);
}

Future<http.Response> handlePatchRequest({
  String baseUrl,
  String modelPath,
  String id,
  Map<String, dynamic> body,
  Map<String, String> filter,
}) async {
  var url = Uri.http(baseUrl, "$modelPath/$id", filter);
  return http.patch(url,
      body: json.encode(body), headers: {"Content-Type": "application/json"});
}

Future<http.Response> handleDeleteRequest(
    {String baseUrl,
    String modelPath,
    String exactPath = "",
    Map<String, String> filter}) async {
  var url = Uri.http(baseUrl, "$modelPath/$exactPath", filter);
  return http.delete(
    url,
  );
}
