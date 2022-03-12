import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_tv_guide/http/core/hi_error.dart';
import 'package:smart_tv_guide/navigator/tab_navigator.dart';
import 'package:smart_tv_guide/tools/bloc.dart';
import 'package:smart_tv_guide/util/toast.dart';
import '../dao/login_dao.dart';
import '../widget/button_field.dart';
import '../widget/dropdown_box.dart';
import '../widget/input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _iconAnimation;
  late AnimationController _iconAnimationController;
  final Bloc _bloc = Bloc();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _rePassword = TextEditingController();
  final _dropdown = DropdownBox(const <String>[
    'Select you gender',
    'Male',
    'Female',
    'Neutral',
    'Unknown'
  ], 'Select you gender');

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                                padding: EdgeInsets.only(top: 5.0),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder<bool>(
                                    stream: _bloc.registerSubmitCheck,
                                    builder: (context, snapshot) => ButtonField(
                                      color: Colors.teal,
                                      child: const Icon(
                                          FontAwesomeIcons.signInAlt),
                                      onPressed: snapshot.hasData
                                          ? () => _register(context)
                                          : null,
                                    ),
                                  ),
                                  ButtonField(
                                    color: Colors.lightBlueAccent,
                                    child: const Icon(FontAwesomeIcons.wpforms),
                                    onPressed: () =>
                                        Navigator.pushNamed(context, 'login'),
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
    );
  }

  _register(BuildContext context) async {
    if (_password.text != _rePassword.text) {
      showWarnToast('Different passwords');
      return;
    }
    try {
      // var result = await LoginDao.login("631999273@qq.com", "lxd12345");
      var result = await LoginDao.register(
          _username.text,
          _email.text,
          _password.text,
          _dropdown.selected == _dropdown.list[0]
              ? "null"
              : _dropdown.selected);
      print(_email.text);
      print(_password.text);
      print(result);
      if (result['code'] == 1) {
        showToast('Register Successful');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TabNavigator(),
          ),
        );
      } else {
        showWarnToast('Register Failed');
      }
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _iconAnimationController.dispose();
  }
}
