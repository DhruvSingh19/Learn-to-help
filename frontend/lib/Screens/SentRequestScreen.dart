import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:springsecurity/Constants/generateCallId.dart';
import 'package:springsecurity/Screens/CallingPageScreen.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import '../APiServices/AuthProvider.dart';
import '../APiServices/DataProvider.dart';
import '../Constants/generateChatId.dart';

class SentRequestsScreen extends StatefulWidget {
  const SentRequestsScreen({super.key});

  @override
  State<SentRequestsScreen> createState() => _SentRequestsScreenState();
}

class _SentRequestsScreenState extends State<SentRequestsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadData);
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.fetchSentRequests(
      authProvider.token,
      int.parse(authProvider.id!),
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B3E),
        title: const Text(
          "Sent Requests",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : Consumer<DataProvider>(
                builder: (context, dataProvider, _) {
                  final sentRequests = dataProvider.sentRequests;

                  return RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: const Color(0xFF0D47A1),
                    onRefresh: () async {
                      await dataProvider.fetchSentRequests(
                        authProvider.token,
                        int.parse(authProvider.id!),
                      );
                    },
                    child:
                        sentRequests.isEmpty
                            ? const Center(
                              child: Text(
                                "No sent requests",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            : ListView.builder(
                              itemCount: sentRequests.length,
                              itemBuilder: (context, index) {
                                final req = sentRequests[index];
                                final receiver = req['user2'];
                                final offered = req['skillOffered'];
                                final requested = req['skillRequested'];
                                final status = req['status'];

                                return Card(
                                  color: const Color(0xFF102B5C),
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'To: ${receiver['username']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Offered: ${offered['name']} (${offered['category']})',
                                              style: const TextStyle(color: Colors.white70),
                                            ),
                                            Text(
                                              'Requested: ${requested['name']} (${requested['category']})',
                                              style: const TextStyle(color: Colors.white70),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Status: $status',
                                              style: TextStyle(
                                                color: status == 'ACCEPTED'
                                                    ? Colors.greenAccent
                                                    : Colors.orangeAccent,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 60), // Add space for buttons
                                          ],
                                        ),
                                      ),
                                      if (status == 'ACCEPTED')
                                        Positioned(
                                          bottom: 10,
                                          right: 10,
                                          child: Row(
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ZIMKitMessageListPage(
                                                        conversationID: generateChatId.generate(
                                                          int.parse(authProvider.id!),
                                                          receiver['id']!,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.message_rounded),
                                                label: const Text("Chat"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFF1976D2),
                                                  foregroundColor: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => CallPage(
                                                        callID: generateCallId.generate(
                                                          int.parse(authProvider.id!),
                                                          receiver['id']!,
                                                          offered['id'],
                                                          requested['id'],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.video_call),
                                                label: const Text("Join Meet"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFF1976D2),
                                                  foregroundColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                );

                              },
                            ),
                  );
                },
              ),
    );
  }
}
