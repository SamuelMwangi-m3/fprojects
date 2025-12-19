import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "Manage tasks with style and notifications.",
          image: Icon(Icons.task_alt, size: 150, color: Colors.blue),
        ),
        PageViewModel(
          title: "Organize",
          body: "Stay productive with reminders and due dates.",
          image: Icon(Icons.access_time, size: 150, color: Colors.green),
        ),
      ],
      onDone: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      ),
      showSkipButton: true,
      skip: Text("Skip"),
      next: Icon(Icons.arrow_forward),
      done: Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
