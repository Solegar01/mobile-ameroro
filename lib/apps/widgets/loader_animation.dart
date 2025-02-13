import 'package:flutter/material.dart';
import 'package:mobile_ameroro_app/apps/config/app_config.dart';

class LoaderAnimation extends StatefulWidget {
  const LoaderAnimation({super.key});

  @override
  State<LoaderAnimation> createState() => _LoaderAnimationState();
}

class _LoaderAnimationState extends State<LoaderAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    // _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDot(0, AppConfig.errorColor),
          const SizedBox(width: 4),
          _buildDot(1, AppConfig.secondaryColor),
          const SizedBox(width: 4),
          _buildDot(2, AppConfig.primaryColor),
        ],
      ),
    );
  }

  Widget _buildDot(int index, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double opacity = (_controller.value + index / 3) % 1.0;

        return Opacity(
          opacity: opacity,
          child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        );
      },
    );
  }
}
