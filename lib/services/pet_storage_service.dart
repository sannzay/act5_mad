import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';

class PetStorageService {
  static const String _petKey = 'digital_pet';
  static final PetStorageService _instance = PetStorageService._internal();
  late SharedPreferences _prefs;
  bool _initialized = false;

  factory PetStorageService() {
    return _instance;
  }

  PetStorageService._internal();

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<void> savePet(Pet pet) async {
    await init();
    final petJson = jsonEncode(pet.toJson());
    await _prefs.setString(_petKey, petJson);
  }

  Future<Pet?> loadPet() async {
    await init();
    final petJson = _prefs.getString(_petKey);
    if (petJson == null) return null;
    
    try {
      final petMap = jsonDecode(petJson) as Map<String, dynamic>;
      return Pet.fromJson(petMap);
    } catch (e) {
      print('Error loading pet: $e');
      return null;
    }
  }

  Future<void> deletePet() async {
    await init();
    await _prefs.remove(_petKey);
  }
}
