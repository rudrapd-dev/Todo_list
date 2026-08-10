
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            // ==========================================
            // ROTATING RING ONLY
            // ==========================================

            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * 3.14159265359,
                  child: SizedBox(
                    width: 175,
                    height: 175,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      strokeCap: StrokeCap.round,
                      value: 0.75,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),

            // ==========================================
            // STATIONARY CIRCULAR LOGO
            // ==========================================

            ClipOval(
              child: Image.asset(
                'assets/todo.jpg',
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

