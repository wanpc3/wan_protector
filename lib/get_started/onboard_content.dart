import 'package:flutter/material.dart';
import '../strings/strings.dart';

class OnboardContent extends StatelessWidget{
  const OnboardContent({
    super.key,
    required this.illustration,
    required this.title,
    required this.text,
  });

  final String illustration, title, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              illustration,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          //width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          //width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.activeColor = const Color.fromARGB(255, 0, 0, 0),
    this.inActiveColor = const Color(0xFF868686),
  });

  final bool isActive;
  final Color activeColor, inActiveColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16 /2),
      height: 5,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inActiveColor.withOpacity(0.25),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}

//Demo Data for our Onboarding screen
List<Map<String, dynamic>> demoData = [
  {
    "illustration": "https://i.postimg.cc/L43CKddq/Illustrations.png",
    "title": Strings.get_started_1_title,
    "text": Strings.get_started_1,
  },
  {
    "illustration": "https://i.postimg.cc/xTjs9sY6/Illustrations-1.png",
    "title": Strings.get_started_2_title,
    "text": Strings.get_started_2,
  },
  {
    "illustration": "https://i.postimg.cc/6qcYdZVV/Illustrations-2.png",
    "title": Strings.get_started_3_title,
    "text": Strings.get_started_3,
  },
];