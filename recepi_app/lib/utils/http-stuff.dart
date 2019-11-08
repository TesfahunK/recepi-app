import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:recepi_app/utils/urls.dart' as urls;
import 'package:http/http.dart' as http;

//Method typedefs Request response types
typedef ResponseWithStatusCodeCallBack = void Function(
    dynamic response, int code);
typedef SpecificResponseCallBack = void Function(dynamic response);
typedef BooleanCallBack = void Function(bool loading);

class HttpBaby {
  BooleanCallBack loading;
  BooleanCallBack hasConnectionError;
// **** Request Brokers Callbacks ****
  /// The request broker callbacks methods return the required value(body)
  /// of a response based on a specific status code/event
  ///

  SpecificResponseCallBack onSuccess;
  SpecificResponseCallBack onError;
  SpecificResponseCallBack onNotFound;
  SpecificResponseCallBack onUnauthorized;
  // with body
  ResponseWithStatusCodeCallBack responseWithStatus;

  /// Can launch check the connectivity status of the device
  /// and acts accordingly ,

  HttpBaby(
      {this.onSuccess,
      this.onError,
      this.loading,
      this.onNotFound,
      this.onUnauthorized,
      this.responseWithStatus,
      this.hasConnectionError});

  /// This Method classifies and decides which callback to call
  /// and not call based the passed parameters on the constructor
  ///  it also decode/parses the response body

  void _butler(http.Response response) {
    if (response != null) {
      var decoded = json.decode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          this.onSuccess != null) {
        this.onSuccess(decoded);
      }
      if (response.statusCode == 400 && this.onError != null) {
        this.onError(decoded);
      }
      if (response.statusCode == 401 && this.onUnauthorized != null) {
        this.onUnauthorized(decoded);
      }
      if (response.statusCode == 404 && this.onNotFound != null) {
        this.onNotFound(decoded);
      }
      if (this.loading != null) {
        this.loading(false);
      }
      if (this.responseWithStatus != null) {
        this.responseWithStatus(decoded, response.statusCode);
      }
    }
  }

  /// ** Request Methods  **
  /// These are an http request handlers that process basic CRUD operations
  /// ops like [get] [post] [delete] [update] or [patch] in some cases

  Future handleGetRequest(
      {String modelPath, Map<String, String> filter}) async {
    if (this.loading != null) {
      this.loading(true);
    }

    /// This try block  catches an http SOCKETEXCEPTION
    try {
      var url = Uri.http(urls.base, modelPath, filter);
      http.Response response = await http.get(url);
      _butler(response);
    } on SocketException {
      if (this.hasConnectionError != null) {
        this.hasConnectionError(true);
      }
      if (this.loading != null) {
        this.loading(false);
      }
    }
  }

  Future handlePostRequest(
      {String modelPath,
      dynamic body,
      Map<String, String> headers,
      Map<String, String> filter}) async {
    if (this.loading != null) {
      this.loading(true);
    }
    try {
      var url = Uri.http(urls.base, modelPath, filter);
      http.Response response =
          await http.post(url, body: body, headers: headers);
      _butler(response);
    } catch (e) {
      if (this.hasConnectionError != null) {
        this.hasConnectionError(true);
      }
      if (this.loading != null) {
        this.loading(false);
      }
    }
  }

  handlePatchRequest({
    String modelPath,
    String id,
    Map<String, dynamic> body,
    Map<String, String> filter,
  }) async {
    var url = Uri.http(urls.base, modelPath, filter);
    if (this.loading != null) {
      this.loading(true);
    }
    try {
      http.Response response = await http.patch(url,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});
      _butler(response);
    } catch (e) {
      if (this.hasConnectionError != null) {
        this.hasConnectionError(true);
      }
      if (this.loading != null) {
        this.loading(false);
      }
    }
  }

  Future handleDeleteRequest({
    String modelPath,
    Map<String, String> filter,
  }) async {
    if (this.loading != null) {
      this.loading(true);
    }
    try {
      var url = Uri.http(urls.base, modelPath, filter);
      http.Response response = await http.delete(
        url,
      );
      _butler(response);
    } catch (e) {
      if (this.hasConnectionError != null) {
        this.hasConnectionError(true);
      }
      if (this.loading != null) {
        this.loading(false);
      }
    }
  }
}
