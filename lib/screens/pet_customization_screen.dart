import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetCustomizationScreen extends StatefulWidget {
  final Function(Pet) onPetCreated;

  const PetCustomizationScreen({Key? key, required this.onPetCreated}) : super(key: key);

  @override
  _PetCustomizationScreenState createState() => _PetCustomizationScreenState();
}

class _PetCustomizationScreenState extends State<PetCustomizationScreen> {
  final _nameController = TextEditingController();
  String _selectedPetType = 'Cat';
  final List<String> _petTypes = ['Cat', 'Dog', 'Rabbit', 'Bird'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createPet() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name for your pet')),
      );
      return;
    }

    final pet = Pet(
      name: _nameController.text.trim(),
      type: _selectedPetType,
    );

    widget.onPetCreated(pet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Your Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Pet Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose Pet Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: _petTypes.map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _selectedPetType == type,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedPetType = type;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _createPet,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Create Pet',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
