import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Api {
  static const String _baseURL =
      'https://ims-backend.dev.sandeshsingh.com.np/api';
  static String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzYW5kZXRlY2h0aXBzIiwic3ViIjoxLCJuYW1lIjoiU2FuZGVzaCBTaW5naCIsImVtYWlsIjoic2FuZGVzaHNpbmdoMjY1QGdtYWlsLmNvbSIsImlhdCI6MTYzNDAxOTYxOSwiZXhwIjoxNjY1NTc3MjE5fQ.xeDVgNqDolC1rTDURDKcGn8_EAjJQGRpJV61ItLvRMo';
  postData(data, url) async {
    var response = await http.post(
      Uri.parse(_baseURL + url),
      body: jsonEncode(data),
      headers: _headerConfig(),
    );
    if (response.statusCode == 200) {
      print('success');
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      print('error ${response.body}');
      return jsonDecode(response.body);
    } else {
      print('Unknown error ${response.body}');
      return jsonDecode(response.body);
    }
  }

  getData(url) async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(Duration(milliseconds: 5000));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.get(
          Uri.parse(_baseURL + url),
          headers: _authHeaderConfig(),
        );
        if (response.statusCode == 200) {
          print('success');
          return jsonDecode(response.body);
        }
        if (response.statusCode == 400) {
          print('error ${response.body}');
          return jsonDecode(response.body);
        } else {
          print(response.body);
        }
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  _headerConfig() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};

  _authHeaderConfig() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

  decodeToken(data) {
    Map<String, dynamic> decoded = JwtDecoder.decode(data);
    token = data;
    return decoded;
  }
}