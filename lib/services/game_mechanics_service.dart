import 'dart:async';
import '../models/pet.dart';

class GameMechanicsService {
  static final GameMechanicsService _instance = GameMechanicsService._internal();
  Timer? _gameTimer;
  final List<void Function(Pet)> _statusEffects = [];
  static const updateInterval = Duration(minutes: 1);

  factory GameMechanicsService() {
    return _instance;
  }

  GameMechanicsService._internal();

  void startGame(Pet pet, void Function(Pet) onPetUpdated) {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(updateInterval, (timer) {
      pet.updateStats();

      for (var effect in _statusEffects) {
        effect(pet);
      }

      onPetUpdated(pet);
    });
  }

  void stopGame() {
    _gameTimer?.cancel();
    _gameTimer = null;
    _statusEffects.clear();
  }

  void addStatusEffect(void Function(Pet) effect, {Duration? duration}) {
    _statusEffects.add(effect);
    
    if (duration != null) {
      Timer(duration, () {
        if (_statusEffects.contains(effect)) {
          _statusEffects.remove(effect);
        }
      });
    }
  }

  void addSicknessEffect(Pet pet) {
    final effect = (Pet pet) {
      if (pet.cleanliness < 30 || pet.hunger > 80) {
        pet.health = (pet.health - 5).clamp(0.0, 100.0);
        pet.happiness = (pet.happiness - 5).clamp(0.0, 100.0);
      }
    };
    
    addStatusEffect(effect, duration: const Duration(minutes: 10));
  }

  void addEnergeticEffect(Pet pet) {
    final effect = (Pet pet) {
      if (pet.energy > 80 && pet.happiness > 70) {
        pet.happiness = (pet.happiness + 2).clamp(0.0, 100.0);
        pet.energy = (pet.energy - 3).clamp(0.0, 100.0);
      }
    };
    
    addStatusEffect(effect, duration: const Duration(minutes: 5));
  }

  void addHungryEffect(Pet pet) {
    final effect = (Pet pet) {
      if (pet.hunger > 70) {
        pet.happiness = (pet.happiness - 3).clamp(0.0, 100.0);
        pet.energy = (pet.energy - 2).clamp(0.0, 100.0);
      }
    };
    
    addStatusEffect(effect, duration: const Duration(minutes: 8));
  }
}
