import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/stat_indicator.dart';
import 'dart:async';

class PetScreen extends StatefulWidget {
  final Pet pet;
  final Function(Pet) onPetUpdated;

  const PetScreen({
    Key? key,
    required this.pet,
    required this.onPetUpdated,
  }) : super(key: key);

  @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        widget.pet.updateStats();
        widget.onPetUpdated(widget.pet);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _performAction(String action) {
    setState(() {
      switch (action) {
        case 'feed':
          widget.pet.feed();
          break;
        case 'play':
          widget.pet.play();
          break;
        case 'rest':
          widget.pet.rest();
          break;
        case 'clean':
          widget.pet.clean();
          break;
      }
      widget.onPetUpdated(widget.pet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      widget.pet.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      widget.pet.type,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    StatIndicator(
                      label: 'Happiness',
                      value: widget.pet.happiness,
                      color: Colors.yellow,
                    ),
                    StatIndicator(
                      label: 'Health',
                      value: widget.pet.health,
                      color: Colors.red,
                    ),
                    StatIndicator(
                      label: 'Energy',
                      value: widget.pet.energy,
                      color: Colors.green,
                    ),
                    StatIndicator(
                      label: 'Hunger',
                      value: widget.pet.hunger,
                      color: Colors.orange,
                    ),
                    StatIndicator(
                      label: 'Cleanliness',
                      value: widget.pet.cleanliness,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ActionButton(
                  icon: Icons.restaurant,
                  label: 'Feed',
                  onPressed: () => _performAction('feed'),
                ),
                ActionButton(
                  icon: Icons.sports_esports,
                  label: 'Play',
                  onPressed: () => _performAction('play'),
                ),
                ActionButton(
                  icon: Icons.hotel,
                  label: 'Rest',
                  onPressed: () => _performAction('rest'),
                ),
                ActionButton(
                  icon: Icons.cleaning_services,
                  label: 'Clean',
                  onPressed: () => _performAction('clean'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
      ),
    );
  }
}
