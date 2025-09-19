import 'package:flutter/material.dart';
import 'models/pet.dart';
import 'screens/pet_customization_screen.dart';
import 'screens/pet_screen.dart';
import 'services/pet_storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DigitalPetApp(),
    );
  }
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({Key? key}) : super(key: key);

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  Pet? _pet;
  final _petStorage = PetStorageService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  Future<void> _loadPet() async {
    final pet = await _petStorage.loadPet();
    setState(() {
      _pet = pet;
      _isLoading = false;
    });
  }

  Future<void> _onPetCreated(Pet pet) async {
    await _petStorage.savePet(pet);
    setState(() {
      _pet = pet;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_pet == null) {
      return PetCustomizationScreen(onPetCreated: _onPetCreated);
    }
    return PetScreen(
      pet: _pet!,
      onPetUpdated: (pet) async {
        await _petStorage.savePet(pet);
      },
    );
  }
}