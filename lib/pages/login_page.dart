import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_tv_guide/http/core/hi_error.dart';
import 'package:smart_tv_guide/tools/bloc.dart';
import 'package:smart_tv_guide/util/toast.dart';
import 'package:video_player/video_player.dart';

import '../dao/user_dao.dart';
import '../navigator/hi_navigator.dart';
import '../widget/button_field.dart';
import '../widget/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Animation<double> _iconAnimation;
  late AnimationController _iconAnimationController;
  late VideoPlayerController _videoController;
  final Bloc _bloc = Bloc();
  final _emailText = TextEditingController();
  final _passwordText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/scene.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.addListener(() {
          Duration res = _videoController.value.position,
              v = const Duration(milliseconds: 1200);
          if (res > _videoController.value.duration - v) {
            _videoController.seekTo(Duration.zero);
          }
        });
      });
    _iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: Stack(fit: StackFit.expand, children: [
        Transform.scale(
          scale: _videoController.value.aspectRatio /
              MediaQuery.of(context).size.aspectRatio,
          child: Center(
            child: _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : const CircularProgressIndicator(),
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
              // contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(60),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          child: Stack(
            children: [
              const Positioned(
                left: 15,
                top: 45,
                child: BackButton(),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage("assets/logo.png"),
                        fit: BoxFit.contain,
                        width: _iconAnimation.value * 120.0,
                        color: const Color.fromRGBO(255, 255, 255, 0.9),
                        colorBlendMode: BlendMode.modulate,
                      ),
                      Container(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InputField(
                              stream: _bloc.email,
                              controller: _emailText,
                              onChanged: _bloc.emailChanged,
                              labelText: "Enter email",
                              keyboardType: TextInputType.emailAddress,
                            ),
                            InputField(
                              stream: _bloc.password,
                              controller: _passwordText,
                              onChanged: _bloc.passwordChanged,
                              labelText: "Enter password",
                              obscureText: true,
                              keyboardType: TextInputType.text,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 30.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StreamBuilder<bool>(
                                  stream: _bloc.loginSubmitCheck,
                                  builder: (context, snapshot) => ButtonField(
                                    color: Colors.teal,
                                    child:
                                        const Icon(FontAwesomeIcons.signInAlt),
                                    onPressed: snapshot.hasData
                                        ? () => _login(context)
                                        : null,
                                  ),
                                ),
                                ButtonField(
                                  color: Colors.lightBlueAccent,
                                  child: const Icon(FontAwesomeIcons.wpforms),
                                  onPressed: () => HiNavigator()
                                      .onJumpTo(RouteStatus.registration),
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
      ]),
    );
  }

  _login(BuildContext context) async {
    try {
      var result = await UserDao.login(_emailText.text, _passwordText.text);
      if (result['code'] == 1) {
        showToast('Login Successful');
        HiNavigator().onJumpTo(RouteStatus.home, args: {"page": 0});
      } else {
        showWarnToast('Login Failed');
        showWarnToast(result['reason']);
      }
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _iconAnimationController.dispose();
    _videoController.dispose();
    _bloc.dispose();
    _emailText.dispose();
    _passwordText.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
