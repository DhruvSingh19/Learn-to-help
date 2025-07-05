import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:springsecurity/Screens/AddSkillWithInfoScreen.dart';

import '../APiServices/AuthProvider.dart';
import '../APiServices/DataProvider.dart';

class Addskillscreen extends StatefulWidget {
  const Addskillscreen({super.key});

  @override
  State<Addskillscreen> createState() => _AddskillscreenState();
}

class _AddskillscreenState extends State<Addskillscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.fetchAllSkills(authProvider.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B3E),
        title: const Text(
          'Add Skills',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: Colors.white,
              onRefresh: () async {
                await dataProvider.fetchAllSkills(authProvider.token);
              },
              child: Consumer<DataProvider>(
                builder: (context, dataProvider, _) {
                  final data = dataProvider.skills;

                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        "No skills available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, index) {
                      final skill = data[index];

                      return Card(
                        color: const Color(0xFF102B5C),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(
                            skill['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            skill['category'] ?? 'No Category',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          leading: const Icon(Icons.star, color: Colors.amber),
                          trailing: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Addskillwithinfoscreen(
                                    skillId: skill['id'],
                                    name: skill['name'],
                                    category: skill['category'],
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.chevron_right, color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
