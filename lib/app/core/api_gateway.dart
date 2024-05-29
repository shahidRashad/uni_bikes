import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiGateway {
  static Future<Map<String, dynamic>> service(
      {required Uri url,
      Map<String, String>? header,
      required Map<String, dynamic> body}) async {
    try {
      final response = await http
          .post(url,
              body: jsonEncode(body),
              headers: header ?? {"Content-Type": "application/json"})
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw "Network error";
      }
    } on SocketException {
      throw "Oops, device is offline, please check your internet connection.";
    } on TimeoutException {
      throw 'Its taking longer than usual, please try again';
    } catch (e) {
      if (e == 'respose is empty') {
        throw 'respose is empty';
      } else if (e == 'Network error') {
        throw 'Network error';
      } else {
        throw 'An unexpected error has occurred. Please try again.';
      }
    }
  }
}
