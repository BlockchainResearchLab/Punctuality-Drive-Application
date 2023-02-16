// import 'package:flutter/material.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:punctuality_drive/Screens/login_screen.dart';

// class Splash extends StatefulWidget {
//   const Splash({Key? key}) : super(key: key);

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         bottomSheet: const FadeFooter(),
//         backgroundColor: Colors.white,
//         body: Center(
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 60.0,
//               ),
//               Image.asset(
//                 'images/akgeclogo.png',
//                 width: 200,
//               ),
//               const SizedBox(
//                 height: 100.0,
//               ),
//               SizedBox(
//                 width: 300.0,
//                 child: DefaultTextStyle(
//                   style: const TextStyle(
//                       fontSize: 30.0,
//                       fontFamily: 'popin',
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600),
//                   child: AnimatedTextKit(
//                     isRepeatingAnimation: false,
//                     onFinished: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const LoginPage()),
//                       );
//                     },
//                     animatedTexts: [
//                       TyperAnimatedText(
//                         'PUNCTUALITY DRIVE',
//                         textAlign: TextAlign.center,
//                         speed: const Duration(milliseconds: 170),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FadeFooter extends StatefulWidget {
//   const FadeFooter({super.key});

//   @override
//   State<FadeFooter> createState() => _FadeFooterState();
// }

// class _FadeFooterState extends State<FadeFooter> with TickerProviderStateMixin {
//   late final AnimationController _controller = AnimationController(
//     duration: const Duration(seconds: 4),
//     vsync: this,
//   )..repeat(reverse: true);
//   late final Animation<double> _animation = CurvedAnimation(
//     parent: _controller,
//     curve: Curves.easeIn,
//   );

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: FadeTransition(
//         opacity: _animation,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             SizedBox(
//               height: 150,
//               width: 200,
//               child: Center(
//                 child: Image(
//                   image: AssetImage(
//                     "images/brl_logo.png",
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(
        context,
        //page route after splash screen
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Image.asset(
          'images/punctuality.gif',
        ),
      ),
    );
  }
}
