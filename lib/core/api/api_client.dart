import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cpu_management/core/dev/logger.dart';
import 'package:cpu_management/screens/widget/one_c_common.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

enum _LogMethods {
  get,
  post,
  put,
  delete,
  response,
}

class ApiClient {
  final _retryClient = const RetryOptions(
    maxAttempts: 8,
    delayFactor: Duration(seconds: 2),
    maxDelay: Duration(seconds: 15),
  );

  Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    // await noInternetPopup();
    await noInternet();
    return await _retryClient.retry(
      () async {
        _logit(method: _LogMethods.get, url: url, headers: headers);
        var res = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
          },
        );
        _logit(method: _LogMethods.response, response: res);
        return res;
      },
      onRetry: (p0) => logWarning('Retrying... because of: $p0'),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  Future<http.Response> post({
    required String url,
    Map<String, String>? headers,
    required Map<String, dynamic> body,
    Encoding? encoding,
  }) async {
    // await noInternetPopup();
    await noInternet();
    return await _retryClient.retry(
      () async {
        var mainHeaders = {
          'Content-Type': 'application/json',
          ...?headers,
        };
        var mainBody = jsonEncode(body);
        _logit(
            method: _LogMethods.post, url: url, headers: headers, body: body);
        var res = await http.post(
          Uri.parse(url),
          headers: mainHeaders,
          body: mainBody,
          encoding: encoding,
        );
        _logit(method: _LogMethods.response, response: res);
        return res;
      },
      onRetry: (p0) => logWarning('Retrying... because of: $p0'),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  Future<http.Response> delete({
    required String url,
    Map<String, String>? headers,
    Encoding? encoding,
  }) async {
    // await noInternetPopup();
    await noInternet();
    return await _retryClient.retry(
      () async {
        var mainHeaders = {
          'Content-Type': 'application/json',
          ...?headers,
        };
        _logit(method: _LogMethods.delete, url: url, headers: headers);
        var res = await http.delete(
          Uri.parse(url),
          headers: mainHeaders,
          encoding: encoding,
        );
        _logit(method: _LogMethods.response, response: res);
        return res;
      },
      onRetry: (p0) => logWarning('Retrying... because of: $p0'),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  Future<http.Response> put({
    required String url,
    Map<String, String>? headers,
    required Map<String, dynamic> body,
    Encoding? encoding,
  }) async {
    // await noInternetPopup();
    await noInternet();
    return await _retryClient.retry(
      () async {
        var mainHeaders = {
          'Content-Type': 'application/json',
          ...?headers,
        };
        var mainBody = jsonEncode(body);
        _logit(method: _LogMethods.put, url: url, headers: headers, body: body);
        var res = await http.put(
          Uri.parse(url),
          headers: mainHeaders,
          body: mainBody,
          encoding: encoding,
        );
        _logit(method: _LogMethods.response, response: res);
        return res;
      },
      onRetry: (p0) => logWarning('Retrying... because of: $p0'),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  Future<http.Response> multipartRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, String>? files,
    String? fileKey,
  }) async {
    // await noInternetPopup();
    await noInternet();
    return await _retryClient.retry(
      () async {
        _logit(
            method: _LogMethods.post, url: url, headers: headers, body: body);
        var request = http.MultipartRequest(method, Uri.parse(url));
        request.headers.addAll(headers ?? {});
        body?.forEach((key, value) {
          if (value is http.MultipartFile) {
            request.files.add(value);
          } else {
            request.fields[key] = value.toString();
          }
        });
        files?.forEach((key, value) async {
          request.files.add(await http.MultipartFile.fromPath(
            fileKey ?? 'files',
            value,
          ));
        });
        var res = await request.send();
        var response = await http.Response.fromStream(res);
        _logit(method: _LogMethods.response, response: response);
        return response;
      },
      onRetry: (p0) => logWarning('Retrying... because of: $p0'),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  void _logit({
    required _LogMethods method,
    String? url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    http.Response? response,
  }) {
    switch (method) {
      case _LogMethods.get:
        logWarning('GET: $url');
        logWarning('Headers: $headers');
        break;
      case _LogMethods.post:
        logWarning('POST: $url');
        logWarning('Headers: $headers');
        logWarning('Body: $body');
        break;
      case _LogMethods.put:
        logWarning('PUT: $url');
        logWarning('Headers: $headers');
        logWarning('Body: $body');
        break;
      case _LogMethods.delete:
        logWarning('DELETE: $url');
        logWarning('Headers: $headers');
        break;
      case _LogMethods.response:
        switch (response?.statusCode) {
          case 200:
            logSuccess('Response Code: 200');
            logSuccess('Response: ${response?.body}');
            break;
          case 400:
            logSuccess('Response Code: 400');
            logError('Response: ${response?.body}');
            break;
          case 401:
            logSuccess('Response Code: 401');
            logError('Response: ${response?.body}');
            break;
          case 403:
            logSuccess('Response Code: 403');
            logError('Response: ${response?.body}');
            break;
          case 404:
            logSuccess('Response Code: 404');
            logError('Response: ${response?.body}');
            break;
          case 500:
            logSuccess('Response Code: 500');
            logError('Response: ${response?.body}');
            break;
          default:
            logDebug('Response Code: ${response?.statusCode}');
            logDebug('Response: ${response?.body}');
            break;
        }
        break;
    }
  }
}
