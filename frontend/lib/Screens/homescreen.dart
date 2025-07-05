import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../APiServices/AuthProvider.dart';
import '../APiServices/DataProvider.dart';
import 'ExchangeSkillScreen.dart';
import 'ProfilePage.dart';
import 'ReceivedRequestScreen.dart';
import 'SentRequestScreen.dart';
import 'currentuserskillsscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      dataProvider.fetchAllSkillsByDifferentUsers(
          authProvider.token, int.parse(authProvider.id!));
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF0D1B3E),
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learn to Help',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            // Text(
            //   authProvider.username ?? 'User',
            //   style: const TextStyle(
            //       fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            // ),
          ],
        ),
        actions: [
          _buildRequestsMenu(),
        ],
      ),
      drawer: _buildDrawer(context, authProvider),
      body: _buildBody(dataProvider, authProvider),
    );
  }

  Widget _buildBody(DataProvider dataProvider, AuthProvider authProvider) {
    if (dataProvider.offeredskills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.work_outline, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            const Text('No skills available',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await dataProvider.fetchAllSkillsByDifferentUsers(
                    authProvider.token, int.parse(authProvider.id!));
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await dataProvider.fetchAllSkillsByDifferentUsers(
            authProvider.token, int.parse(authProvider.id!));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dataProvider.offeredskills.length,
        itemBuilder: (context, index) {
          final item = dataProvider.offeredskills[index];
          return _buildSkillCard(item, context);
        },
      ),
    );
  }

  Widget _buildSkillCard(Map<String, dynamic> item, BuildContext context) {
    return Card(
      color: Color(0xFF102B5C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item['skill']['name'] ?? 'N/A',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Chip(
                  label: Text(item['skill']['category'] ?? 'N/A',
                      style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(item['user']['username'] ?? 'N/A',style: TextStyle(color: Colors.white),),
                const Spacer(),
                const Icon(Icons.location_on, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(item['user']['location'] ?? 'N/A',style: TextStyle(color: Colors.white),),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item['description'] ?? 'No description',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildRatingStars(double.parse(
                    item['user']['rating']?.toStringAsFixed(1) ?? '0.0')),
                const SizedBox(width: 8),
                Text(item['user']['rating']?.toStringAsFixed(1) ?? '0.0',style: TextStyle(color: Colors.white),),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExchangeSkillScreen(
                          receiverUserId: item['user']['id'],
                          requestedSkillId: item['skill']['id'],
                          description: item['description'] ?? 'No description',
                        ),
                      ),
                    );
                  },
                  child: const Text('Request'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : (index < rating ? Icons.star_half : Icons.star_border),
          size: 16,
          color: Colors.amber,
        );
      }),
    );
  }

  Widget _buildRequestsMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
      color: const Color(0xFF0D1B3E),
      onSelected: (value) {
        if (value == 'sent') {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SentRequestsScreen()));
        } else if (value == 'received') {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ReceivedRequestsScreen()));
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'sent',
          child: Row(
            children: const [
              Icon(Icons.send, color: Colors.white),
              SizedBox(width: 8),
              Text('Sent Requests', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'received',
          child: Row(
            children: const [
              Icon(Icons.inbox, color: Colors.white),
              SizedBox(width: 8),
              Text('Received Requests', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      backgroundColor: Color(0xFF0D1B3E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:
            const BoxDecoration(color: Color(0xFF0D1B3E)), // lighter blue
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF0D47A1)),
                ),
                const SizedBox(height: 8),
                Text(
                  authProvider.username ?? 'User',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text('ID: ${authProvider.id ?? ''}',
                    style: TextStyle(color: Colors.white.withOpacity(0.8))),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('My Profile', style: TextStyle(color: Colors.white)),
            onTap: () {
              // In your navigation:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.work, color: Colors.white),
            title: const Text('My Skills', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurrentuserskillsScreen(),
                ),
              );
            },
          ),
          const Divider(color: Colors.white54),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () async {
              try {
                await Provider.of<AuthProvider>(context, listen: false).logout();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout Failed')));
              }
            },
          ),
        ],
      ),
    );
  }
}
