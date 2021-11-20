import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Api {
  static const String _baseURL = 'http://10.0.2.2:8000/api';
  static String token = '';
  postData(data, url) async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(milliseconds: 5000));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.post(
          Uri.parse(_baseURL + url),
          body: jsonEncode(data),
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
          print('Unknown error ${response.body}');
          return jsonDecode(response.body);
        }
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  getData(url) async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(milliseconds: 5000));
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
