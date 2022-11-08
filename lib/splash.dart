import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:punctuality_drive/login_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: const FadeFooter(),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Image.asset(
                'images/akgeclogo.png',
                width: 300,
              ),
              const SizedBox(
                height: 40.0,
              ),
              SizedBox(
                width: 300.0,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'popin',
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    onFinished: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    animatedTexts: [
                      TyperAnimatedText(
                        'PUNCTUALITY DRIVE',
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FadeFooter extends StatefulWidget {
  const FadeFooter({super.key});

  @override
  State<FadeFooter> createState() => _FadeFooterState();
}

class _FadeFooterState extends State<FadeFooter> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FadeTransition(
        opacity: _animation,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 200,
              width: 300,
              child: Center(
                child: Image(
                  image: AssetImage(
                    "images/brl_logo.png",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
