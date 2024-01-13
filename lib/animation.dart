import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'model/partical.dart';
import 'widgets/painter.dart';

class FunnyAnimation extends StatefulWidget {
  const FunnyAnimation({Key? key}) : super(key: key);

  @override
  _FunnyAnimationState createState() => _FunnyAnimationState();
}

class _FunnyAnimationState extends State<FunnyAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  List<Particle> particles = [];

  //this items for animations  createa random size
  //and color Randoms

  genereteListOfParticles() {
    int numberOfParticles = 200;
    for (int i = 0; i < numberOfParticles; i++) {
      double randomSize = math.Random().nextDouble() * 20;
      int randomR = math.Random().nextInt(256);
      int randomG = math.Random().nextInt(256);
      int randomB = math.Random().nextInt(256);

      Color randomColor = Color.fromARGB(255, randomR, randomG, randomB);
      double thetaRandom = math.Random().nextDouble() * (2 * math.pi);

      double radiusRandom = math.Random().nextDouble() * 100 + 20;

      Particle particle = Particle(
          size: randomSize,
          color: randomColor,
          startingTheta: thetaRandom,
          radius: radiusRandom);
      particles.add(particle);
    }
  }

  @override
  void initState() {
    super.initState();
    genereteListOfParticles();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    Tween<double> _rotationTween = Tween(begin: 0, end: 2 * math.pi);
    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.repeat(max: 1);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context);

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomPaint(
          painter: MyPainter(particles: particles, theta: animation.value),
        ),
      ),
    );
  }
}
