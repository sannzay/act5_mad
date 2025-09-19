import 'package:flutter/material.dart';
import '../models/pet.dart';

class AnimatedPet extends StatefulWidget {
  final Pet pet;
  final String action;

  const AnimatedPet({
    Key? key,
    required this.pet,
    this.action = 'idle',
  }) : super(key: key);

  @override
  _AnimatedPetState createState() => _AnimatedPetState();
}

class _AnimatedPetState extends State<AnimatedPet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: -20.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.action != 'idle') {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void didUpdateWidget(AnimatedPet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.action != oldWidget.action && widget.action != 'idle') {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPetEmoji() {
    String emoji;
    switch (widget.pet.type.toLowerCase()) {
      case 'cat':
        emoji = '🐱';
        break;
      case 'dog':
        emoji = '🐶';
        break;
      case 'rabbit':
        emoji = '🐰';
        break;
      case 'bird':
        emoji = '🐦';
        break;
      default:
        emoji = '🐱';
    }
    return Text(
      emoji,
      style: const TextStyle(fontSize: 72),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPetEmoji(),
                if (widget.action != 'idle')
                  _buildActionEffect(widget.action),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionEffect(String action) {
    IconData icon;
    Color color;
    switch (action) {
      case 'feed':
        icon = Icons.restaurant;
        color = Colors.orange;
        break;
      case 'play':
        icon = Icons.sports_esports;
        color = Colors.blue;
        break;
      case 'rest':
        icon = Icons.hotel;
        color = Colors.purple;
        break;
      case 'clean':
        icon = Icons.cleaning_services;
        color = Colors.green;
        break;
      default:
        return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _controller,
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }
}
