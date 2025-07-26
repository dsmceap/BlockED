import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../Constants.dart';
import 'HTTP.dart';

class API {

  static Future<Map<String,dynamic>> verifyCertificate(String hash) async {

    const endpoint ='https://snf-78415.ok-kno.grnetcloud.net/certificates/verify';
    // var payload = json.encode({"data": did});
    var payload = json.encode({
      "hashed_data": hash,
    });
    String basicAuth = 'Basic ${base64Encode(utf8.encode('client:supersecret'))}';
    Map<String, String> headers = {};
    headers['Content-Type'] = 'application/json';
    headers['X-Blocked-Client'] = 'client';
    headers['X-API-Token'] = 'client_api_token';
    headers['authorization'] = basicAuth;

    var t = await HTTP.post(endpoint, payload, headers);

    if([200,400,409].contains(t.item1)) {
      Map<String, dynamic> response = json.decode(t.item2);
      return response;
    } else {
      throw("Could not complete verification");
    }
  }

}