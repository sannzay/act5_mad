import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/stat_indicator.dart';
import '../widgets/animated_pet.dart';
import '../widgets/energy_bar.dart';
import '../widgets/activity_selector.dart';
import '../services/game_mechanics_service.dart';
import '../services/game_state_service.dart';
import '../screens/pet_customization_screen.dart';
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
  final GameMechanicsService _gameMechanics = GameMechanicsService();
  final GameStateService _gameState = GameStateService();
  String _currentAction = 'idle';
  Timer? _gameStateCheckTimer;
  bool _isCharging = false;

  final List<Activity> _activities = [
    Activity(
      name: 'Play',
      icon: Icons.sports_esports,
      color: Colors.blue,
      energyCost: 20,
      happinessGain: 15,
      description: 'Play with your pet to increase happiness',
    ),
    Activity(
      name: 'Play',
      icon: Icons.sports_basketball,
      color: Colors.green,
      energyCost: 30,
      happinessGain: 20,
      description: 'Play with your pet to increase happiness',
    ),
    Activity(
      name: 'Train',
      icon: Icons.school,
      color: Colors.purple,
      energyCost: 25,
      happinessGain: 10,
      description: 'Train your pet new tricks',
    ),
    Activity(
      name: 'Groom',
      icon: Icons.brush,
      color: Colors.orange,
      energyCost: 15,
      happinessGain: 12,
      description: 'Groom your pet to maintain cleanliness',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _gameMechanics.startGame(widget.pet, (pet) {
      setState(() {});
      widget.onPetUpdated(pet);
    });

    // Check game state every second
    _gameStateCheckTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _gameState.checkGameState(widget.pet, context),
    );
  }

  @override
  void dispose() {
    _gameMechanics.stopGame();
    _gameStateCheckTimer?.cancel();
    super.dispose();
  }

  void _performActivity(Activity activity) {
    if (widget.pet.energy < activity.energyCost) {
      return;
    }

    setState(() {
      _currentAction = activity.name.toLowerCase();
      widget.pet.energy = (widget.pet.energy - activity.energyCost).clamp(0.0, 100.0);
      widget.pet.happiness = (widget.pet.happiness + activity.happinessGain).clamp(0.0, 100.0);
      widget.pet.hunger = (widget.pet.hunger + activity.energyCost * 0.3).clamp(0.0, 100.0);
      
      if (widget.pet.energy < 30) {
        _gameMechanics.addHungryEffect(widget.pet);
      }
      
      widget.onPetUpdated(widget.pet);
    });

    // Show charging animation while resting
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _currentAction = 'idle';
        });
      }
    });
  }

  void _showQuitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Quit Current Game?',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'Are you sure you want to quit the current game and start over? '
          'All progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => PetCustomizationScreen(
                    onPetCreated: (pet) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => PetScreen(
                            pet: pet,
                            onPetUpdated: widget.onPetUpdated,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Quit and Replay'),
          ),
        ],
      ),
    );
  }

  void _performAction(String action) {
    setState(() {
      _currentAction = action;
      switch (action) {
        case 'feed':
          widget.pet.feed();
          if (widget.pet.hunger < 30) {
            _gameMechanics.addEnergeticEffect(widget.pet);
          }
          break;
        case 'rest':
          _isCharging = true;
          widget.pet.rest();
          if (widget.pet.energy > 80) {
            _gameMechanics.addEnergeticEffect(widget.pet);
          }
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isCharging = false;
              });
            }
          });
          break;
      }
      widget.onPetUpdated(widget.pet);
    });

    // Reset action to idle after animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _currentAction = 'idle';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => _showQuitConfirmation(context),
              icon: const Icon(Icons.replay),
              label: const Text('Quit & Replay'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red.shade400,
              ),
            ),
          ),
        ],
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
                    AnimatedPet(
                      pet: widget.pet,
                      action: _currentAction,
                    ),
                    const SizedBox(height: 16),
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
                      label: 'Hunger',
                      value: widget.pet.hunger,
                      color: Colors.orange,
                    ),
                    StatIndicator(
                      label: 'Cleanliness',
                      value: widget.pet.cleanliness,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    EnergyBar(
                      energy: widget.pet.energy,
                      isCharging: _isCharging,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ActivitySelector(
                activities: _activities,
                currentEnergy: widget.pet.energy,
                onActivitySelected: _performActivity,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                    icon: Icons.restaurant,
                    label: 'Feed',
                    onPressed: () => _performAction('feed'),
                  ),
                  ActionButton(
                    icon: Icons.hotel,
                    label: 'Rest',
                    onPressed: () => _performAction('rest'),
                  ),
                ],
              ),
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
