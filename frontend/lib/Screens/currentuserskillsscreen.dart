import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../APiServices/AuthProvider.dart';
import '../APiServices/DataProvider.dart';
import 'AddSkillScreen.dart';

class CurrentuserskillsScreen extends StatefulWidget {
  const CurrentuserskillsScreen({super.key});

  @override
  State<CurrentuserskillsScreen> createState() => _CurrentuserskillsScreenState();
}

class _CurrentuserskillsScreenState extends State<CurrentuserskillsScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B3E),
        title: const Text(
          'Your Skills',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: dataProvider.fetchAllSkillsById(
                  authProvider.token, int.parse(authProvider.id!)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
                  );
                }

                final data = snapshot.data as List<dynamic>;

                if (data.isEmpty) {
                  return const Center(
                    child: Text("No skills added yet", style: TextStyle(color: Colors.white)),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, index) {
                    final item = data[index];

                    final skillName = item['skill']['name'] ?? 'N/A';
                    final category = item['skill']['category'] ?? 'N/A';
                    final proficiency = item['proficiency'] ?? 'N/A';
                    final description = item['description'] ?? 'No Description';
                    final rating = item['user']['rating']?.toStringAsFixed(1) ?? '0.0';

                    return Card(
                      color: const Color(0xFF102B5C), // Darker navy for card
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              skillName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text("Category: $category", style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text("Proficiency: $proficiency", style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text("Description: $description", style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text("Rating: $rating", style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Addskillscreen()));
        },
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
