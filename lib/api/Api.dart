import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Api {
  static String _baseURL = 'https://ims-backend.dev.sandeshsingh.com.np/api';
  static String token = '';
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
    }
    else {
      print('Unknown error ${response.body}');
      return jsonDecode(response.body);
    }
  }

  getData(url) async {
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
    }
  }

  _headerConfig() => {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

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