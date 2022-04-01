import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_tv_guide/http/core/request_error.dart';
import 'package:smart_tv_guide/tools/bloc.dart';
import '../dao/user_dao.dart';
import '../http/core/route_jump_listener.dart';
import '../navigator/my_navigator.dart';
import '../util/view_util.dart';
import '../widget/button_field.dart';
import '../widget/dropdown_box.dart';
import '../widget/input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Animation<double> _iconAnimation;
  late AnimationController _iconAnimationController;
  final Bloc _bloc = Bloc();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _rePassword = TextEditingController();
  final _checkCode = TextEditingController();
  final _dropdown = DropdownBox(
    DropdownController(
      <String>['Select you gender', 'Male', 'Female', 'Neutral', 'Unknown'],
      'Select you gender',
    ),
  );
  String checkCode = '';
  late Timer _timer;
  bool freeze = false;
  int count = 21;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Image(
              image: AssetImage("assets/girl.jpeg"),
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: Colors.white,
            ),
            Positioned(
              left: 15,
              top: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlueAccent.withOpacity(0.5),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back),
              ),
            ),
            Theme(
              data: ThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: const Color.fromRGBO(210, 207, 207, 0.8),
                  filled: true,
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(100, 100, 100, 1),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: const AssetImage("assets/logo.png"),
                            fit: BoxFit.contain,
                            width: _iconAnimation.value * 100.0,
                            color: const Color.fromRGBO(255, 255, 255, 0.9),
                            colorBlendMode: BlendMode.modulate,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5.0),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InputField(
                                  height: 90,
                                  stream: _bloc.email,
                                  controller: _email,
                                  onChanged: _bloc.emailChanged,
                                  labelText: "Enter email",
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                InputField(
                                  height: 90,
                                  stream: _bloc.username,
                                  controller: _username,
                                  onChanged: _bloc.usernameChanged,
                                  labelText: "Enter username",
                                  keyboardType: TextInputType.text,
                                ),
                                InputField(
                                  height: 90,
                                  stream: _bloc.password,
                                  controller: _password,
                                  onChanged: _bloc.passwordChanged,
                                  labelText: "Enter password",
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                ),
                                InputField(
                                  height: 90,
                                  stream: _bloc.password,
                                  controller: _rePassword,
                                  onChanged: _bloc.passwordChanged,
                                  labelText: "Enter password again",
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                ),
                                _dropdown,
                                const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StreamBuilder<bool>(
                                      stream: _bloc.registerSubmitCheck,
                                      builder: (context, snapshot) =>
                                          ButtonField(
                                        height: 50,
                                        width: 135,
                                        color: freeze
                                            ? Colors.blueGrey
                                            : Colors.teal,
                                        child: freeze
                                            ? Text(
                                                '$count',
                                                style: const TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : const Icon(
                                                FontAwesomeIcons.signInAlt),
                                        onPressed: snapshot.hasData && !freeze
                                            ? () => _register(context)
                                            : null,
                                      ),
                                    ),
                                    InputField(
                                      height: 50,
                                      width: 135,
                                      controller: _checkCode,
                                      labelText: "Check Code",
                                      labelStyle: const TextStyle(fontSize: 13),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _register(BuildContext context) async {
    if (_password.text != _rePassword.text) {
      showWarnToast('Different passwords');
      return;
    }
    try {
      if (_checkCode.text.isEmpty && !freeze) {
        freeze = true;
        var result = await UserDao.sendCheckCode(_email.text, _username.text);
        if (result['code'] == 0) {
          showWarnToast(result['reason']);
        } else {
          showToast('A check code is sending to your email');
          checkCode = result[_email.text];
        }
        _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
          if (count-- == 0) {
            _timer.cancel();
            freeze = false;
            count = 16;
          }
          setState(() {});
        });
      } else {
        if (checkCode == _checkCode.text) {
          DropdownController controller = _dropdown.dropdownController!;
          var result = await UserDao.register(
              _username.text,
              _email.text,
              _password.text,
              controller.selected == controller.list[0]
                  ? "null"
                  : controller.selected);
          if (result['code'] == 1) {
            showToast('Register Successful');
            MyNavigator().onJumpTo(RouteStatus.home, args: {"page": 0});
          } else {
            showWarnToast('Register Failed');
            showWarnToast(result['reason']);
          }
        } else {
          showWarnToast('The check code is incorrect');
        }
      }
    } on RequestError catch (e) {
      showWarnToast(e.message);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _iconAnimationController.dispose();
    _bloc.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _rePassword.dispose();
    _checkCode.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
