import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:myapp/ui/home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _navigateToHome() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Explore os próximos eventos perto de você",
            body:
                "Uma breve descrição sobre como esta funcionalidade pode te ajudar a aproveitar mais.",
            image: Image.asset('assets/images/onboarding1.png'),
          ),
          PageViewModel(
            title: "Tenha um calendário de eventos moderno",
            body:
                "Uma breve descrição sobre como esta funcionalidade pode te ajudar a aproveitar mais.",
            image: Image.asset('assets/images/onboarding2.png'),
          ),
          PageViewModel(
            title: "Encontre eventos e atividades próximas no mapa",
            body:
                "Uma breve descrição sobre como esta funcionalidade pode te ajudar a aproveitar mais.",
            image: Image.asset('assets/images/onboarding3.png'),
          ),
        ],
        onDone: () {
          _navigateToHome();
        },
        onSkip: () {
          _navigateToHome();
        },
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Text("Next"),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
