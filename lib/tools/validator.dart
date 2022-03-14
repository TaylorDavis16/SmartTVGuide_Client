import 'dart:async';

mixin Validators {
  var emailValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      String regexEmail =
          "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
      if (RegExp(regexEmail).hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError("Email is not valid");
      }
    },
  );

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      String letterDigit = "^[a-z0-9A-Z]+\$";
      if (RegExp(letterDigit).hasMatch(password) && password.length > 6) {
        sink.add(password);
      } else {
        sink.addError("Invalid password! Length must > 6.");
      }
    },
  );

  var usernameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink) {
      String letterDigit = "^[a-zA-Z0-9_\u4e00-\u9fa5]{4,16}\$";
      if (RegExp(letterDigit).hasMatch(username)) {
        sink.add(username);
      } else {
        sink.addError("4-16 characters");
      }
    },
  );
}
