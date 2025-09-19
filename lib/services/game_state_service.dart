import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../screens/pet_customization_screen.dart';
import '../screens/pet_screen.dart';

enum GameState {
  playing,
  won,
  lost,
}

class GameStateService {
  static final GameStateService _instance = GameStateService._internal();
  Timer? _happinessTimer;
  GameState _currentState = GameState.playing;
  final _happinessThreshold = 80.0;
  final _winDuration = const Duration(minutes: 3);
  DateTime? _highHappinessStartTime;

  factory GameStateService() {
    return _instance;
  }

  GameStateService._internal();

  GameState get currentState => _currentState;

  void checkGameState(Pet pet, BuildContext context) {
    if (_currentState != GameState.playing) return;

    // Check win condition
    if (pet.happiness > _happinessThreshold) {
      _highHappinessStartTime ??= DateTime.now();
      
      final timeDifference = DateTime.now().difference(_highHappinessStartTime!);
      if (timeDifference >= _winDuration) {
        _win(context);
      }
    } else {
      _highHappinessStartTime = null;
    }

    // Check loss condition
    if (pet.hunger >= 100 && pet.happiness <= 10) {
      _lose(context);
    }
  }

  void _win(BuildContext context) {
    _currentState = GameState.won;
    _showGameEndDialog(
      context,
      'Congratulations!',
      'Your pet is thriving! You\'ve kept them happy for ${_winDuration.inMinutes} minutes straight!',
      Colors.green,
    );
  }

  void _lose(BuildContext context) {
    _currentState = GameState.lost;
    _showGameEndDialog(
      context,
      'Game Over',
      'Your pet is too hungry and unhappy. Would you like to try again?',
      Colors.red,
    );
  }

  void restartGame(BuildContext context) {
    _currentState = GameState.playing;
    _highHappinessStartTime = null;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PetCustomizationScreen(
          onPetCreated: (pet) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => PetScreen(
                  pet: pet,
                  onPetUpdated: (pet) {},
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showGameEndDialog(
    BuildContext context,
    String title,
    String message,
    Color color,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 16),
            if (_currentState == GameState.won)
              const Text(
                'Feel free to keep playing with your pet!',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_currentState == GameState.lost) {
                restartGame(context);
              }
            },
            child: Text(_currentState == GameState.won ? 'Continue' : 'New Game'),
          ),
        ],
      ),
    );
  }

  void reset() {
    _currentState = GameState.playing;
    _highHappinessStartTime = null;
  }
}
