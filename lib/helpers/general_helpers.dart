import 'package:ims_flutter/api/api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

getErrorMessage(error) {
  var message = error.split('[')[1];
  var finalMsg = message.toString().split(']')[0];
  return finalMsg;
}

isAuthenticated() {
  var token = Api.token;
  if (token == '') {
    return false;
  } else if (JwtDecoder.isExpired(token)) {
    return false;
  } else {
    return true;
  }
}