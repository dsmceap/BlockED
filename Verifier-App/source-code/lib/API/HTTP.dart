import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

/// static methods for performing HTTP requests.
/// Each method returns the status code (int) and the response text (String).
/// Method must be provided with the URL (String), a body (String) and
/// optionally a token.
class HTTP {

  static Future<Tuple2<int, String>> get(String endpoint, Map<String, String> headers)
  async {

    final url = Uri.parse(endpoint);

    var response = await http.get(url, headers: headers);

/*    print("------------------ HTTP GET REQUEST -------------------");
    print(" URL: ${url}");
    print(" headers: ${headers.toString()}");
    print("------------------ HTTP GET REQUEST -------------------");
 */
    return Tuple2<int, String>(response.statusCode, Utf8Decoder().convert(response.bodyBytes));
  }

  static Future<Tuple2<int, String>> post(String endpoint, String payload, Map<String, String> headers) async {

    final url = Uri.parse(endpoint);

    var response = await http.post(url, headers: headers, body: payload);

/*    print("------------------ HTTP POST REQUEST -------------------");
    print(" URL: ${url}");
    print(" headers: ${headers.toString()}");
    print(" body: ${payload}");
    print("------------------ HTTP POST REQUEST -------------------");

 */

    try {
      return Tuple2<int, String>(response.statusCode, response.body);
    } catch (e) {
      return Tuple2<int, String>(-1, e.toString());
    }
  }

  static Future<Tuple2<int, String>> delete(String endpoint,
      Map<String, String> headers) async {

    final url = Uri.parse(endpoint);

    var response = await http.delete(url, headers: headers);

/*    print("------------------ HTTP DELETE REQUEST -------------------");
    print(" URL: ${url}");
    print(" headers: ${headers.toString()}");
    print("------------------ HTTP DELETE REQUEST -------------------");
 */
    return Tuple2<int, String>(response.statusCode, response.body);
  }

  static Future<Tuple2<int, String>> put(String endpoint, String payload,
      [String? token, String? userId]) async {

    final url = Uri.parse(endpoint);

    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/json';

    var response = await http.put(url, headers: headers, body: payload);

    try {
      return Tuple2<int, String>(response.statusCode, response.body);
    } catch (e) {
      return Tuple2<int, String>(-1, e.toString());
    }
  }

}