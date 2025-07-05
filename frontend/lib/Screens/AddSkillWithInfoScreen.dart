import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../APiServices/AuthProvider.dart';
import '../APiServices/DataProvider.dart';

class Addskillwithinfoscreen extends StatefulWidget {
  final int skillId;
  final String name;
  final String category;

  const Addskillwithinfoscreen({
    super.key,
    required this.skillId,
    required this.name,
    required this.category,
  });

  @override
  State<Addskillwithinfoscreen> createState() => _AddskillwithinfoscreenState();
}

class _AddskillwithinfoscreenState extends State<Addskillwithinfoscreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedProficiency;

  final List<String> _proficiencyOptions = [
    'BEGINNER',
    'INTERMEDIATE',
    'ADVANCED',
    'EXPERT',
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B3E),
        title: const Text(
          "Add Skill Details",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Skill: ${widget.name}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Category: ${widget.category}",
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              dropdownColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Proficiency',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              value: _selectedProficiency,
              items: _proficiencyOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedProficiency = newValue;
                });
              },
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> newSkill = {
                    "proficiency": _selectedProficiency,
                    "description": _descriptionController.text,
                    "user": {
                      "id": authProvider.id,
                    },
                    "skill": {
                      "id": widget.skillId,
                    }
                  };
                  await Provider.of<DataProvider>(context, listen: false)
                      .addSkillForCurrentUser(authProvider.token, newSkill);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
