import 'package:flutter/material.dart';

class Pet {
  String name;
  String type;
  double happiness;
  double hunger;
  double health;
  double energy;
  double cleanliness;
  DateTime lastInteraction;
  
  Pet({
    required this.name,
    required this.type,
    this.happiness = 100.0,
    this.hunger = 0.0,
    this.health = 100.0,
    this.energy = 100.0,
    this.cleanliness = 100.0,
  }) : lastInteraction = DateTime.now();

  void feed() {
    if (hunger > 0) {
      hunger = (hunger - 20).clamp(0.0, 100.0);
      happiness = (happiness + 5).clamp(0.0, 100.0);
      energy = (energy + 10).clamp(0.0, 100.0);
    }
    _updateLastInteraction();
  }

  void play() {
    if (energy >= 20) {
      happiness = (happiness + 15).clamp(0.0, 100.0);
      energy = (energy - 20).clamp(0.0, 100.0);
      hunger = (hunger + 10).clamp(0.0, 100.0);
      cleanliness = (cleanliness - 10).clamp(0.0, 100.0);
    }
    _updateLastInteraction();
  }

  void rest() {
    energy = (energy + 30).clamp(0.0, 100.0);
    hunger = (hunger + 5).clamp(0.0, 100.0);
    _updateLastInteraction();
  }

  void clean() {
    cleanliness = 100.0;
    happiness = (happiness + 10).clamp(0.0, 100.0);
    _updateLastInteraction();
  }

  void updateStats() {
    final now = DateTime.now();
    final difference = now.difference(lastInteraction).inMinutes;
    
    if (difference > 0) {
      // Decrease stats over time
      hunger = (hunger + difference * 0.5).clamp(0.0, 100.0);
      energy = (energy - difference * 0.3).clamp(0.0, 100.0);
      cleanliness = (cleanliness - difference * 0.2).clamp(0.0, 100.0);
      
      // Happiness decreases if needs are not met
      if (hunger > 70 || energy < 30 || cleanliness < 30) {
        happiness = (happiness - difference * 0.5).clamp(0.0, 100.0);
      }
      
      // Health decreases if multiple needs are critical
      int criticalNeeds = 0;
      if (hunger > 90) criticalNeeds++;
      if (energy < 10) criticalNeeds++;
      if (cleanliness < 10) criticalNeeds++;
      if (happiness < 10) criticalNeeds++;
      
      if (criticalNeeds >= 2) {
        health = (health - difference * criticalNeeds * 0.1).clamp(0.0, 100.0);
      }
    }
  }

  void _updateLastInteraction() {
    lastInteraction = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'happiness': happiness,
      'hunger': hunger,
      'health': health,
      'energy': energy,
      'cleanliness': cleanliness,
      'lastInteraction': lastInteraction.toIso8601String(),
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'],
      type: json['type'],
      happiness: json['happiness'],
      hunger: json['hunger'],
      health: json['health'],
      energy: json['energy'],
      cleanliness: json['cleanliness'],
    )..lastInteraction = DateTime.parse(json['lastInteraction']);
  }
}
