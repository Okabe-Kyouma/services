import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:services/auth/addharAuth/enter_aadhar_number.dart';
import 'package:services/auth/login/login.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  var currentAnimation = 0;

  @override
  void initState() {
    super.initState();
    _playAnimations();
  }

  final List<String> animations = [
    // "assets/lottie/l1.json",

    "assets/lottie/l12.json",
    "assets/lottie/l11.json",
    "assets/lottie/l5.json",
    "assets/lottie/l13.json",
    "assets/lottie/l3.json",
    "assets/lottie/l14.json",
    "assets/lottie/l2.json",
    "assets/lottie/l10.json",
    "assets/lottie/l15.json",
  ];

  final List<String> animationText = [
    'Find Cleaners near you!',
    'Find Painters near you!',
    'Find Teachers near you!',
    'Find Electricians near you!',
    'Find Gardeners near you!',
    'Find Artists near you!',
    'Find Carpentars near you!',
    'Find Plumbers near you!',
    'And many more!',
  ];

  Future<void> _playAnimations() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        currentAnimation = (currentAnimation + 1) % animations.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        height: double.infinity,
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: Image.asset('assets/logos/services_logo.png'),
              ),
              SizedBox(
                width: 350,
                height: 350,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    const begin = Offset(-1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  child: Lottie.asset(
                    animations[currentAnimation],
                    key: ValueKey<int>(currentAnimation),
                    repeat: false,
                  ),
                ),
              ),
              Text(
                animationText[currentAnimation],
                style:
                    GoogleFonts.montserrat(fontSize: 23, color: Colors.white),
              ),
              const SizedBox(height: 25),
              Text(
                "OR",
                style:
                    GoogleFonts.montserrat(fontSize: 28, color: Colors.white),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Find Work Yourself!',
                style:
                    GoogleFonts.montserrat(fontSize: 28, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                            settings: const RouteSettings(name: "/login"),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Number()),
                        );
                      },
                      child: const Text(
                        'Signup',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
