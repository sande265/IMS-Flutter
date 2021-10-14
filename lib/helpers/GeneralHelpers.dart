getErrorMessage(error) {
  var message = error.split('[')[1];
  var finalMsg = message.toString().split(']')[0];
  return finalMsg;
}
