import 'dart:async';
import 'validator.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _usernameController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;

  Function(String) get passwordChanged => _passwordController.sink.add;

  Function(String) get usernameChanged => _usernameController.sink.add;

  //Another way
  // StreamSink<String> get emailChanged => _emailController.sink;
  // StreamSink<String> get passwordChanged => _passwordController.sink;

  Stream<String> get email => _emailController.stream.transform(emailValidator);

  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidator);

  Stream<bool> get loginSubmitCheck =>
      Rx.combineLatest2(email, password, (e, p) => true);

  Stream<bool> get registerSubmitCheck =>
      Rx.combineLatest3(email, password, username, (e, p, u) => true);

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _usernameController.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
