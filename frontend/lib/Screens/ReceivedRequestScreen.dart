import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:springsecurity/Constants/generateChatId.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import '../APiServices/AuthProvider.dart';
import '../APiServices/DataProvider.dart';
import '../Constants/generateCallId.dart';
import 'CallingPageScreen.dart';

class ReceivedRequestsScreen extends StatefulWidget {
  const ReceivedRequestsScreen({super.key});

  @override
  State<ReceivedRequestsScreen> createState() => _ReceivedRequestsScreenState();
}

class _ReceivedRequestsScreenState extends State<ReceivedRequestsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadData);
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.fetchReceivedRequests(
      authProvider.token,
      int.parse(authProvider.id!),
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B3E),
        title: const Text(
          "Received Requests",
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
                  final receivedRequests = dataProvider.receivedRequests;

                  return RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: const Color(0xFF0D47A1),
                    onRefresh: () async {
                      await dataProvider.fetchReceivedRequests(
                        authProvider.token,
                        int.parse(authProvider.id!),
                      );
                    },
                    child:
                        receivedRequests.isEmpty
                            ? const Center(
                              child: Text(
                                "No requests received.",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            : ListView.builder(
                              itemCount: receivedRequests.length,
                              itemBuilder: (context, index) {
                                final req = receivedRequests[index];
                                final sender = req['user1'];
                                final offered = req['skillOffered'];
                                final requested = req['skillRequested'];
                                final status = req['status'];

                                return Card(
                                  color: const Color(0xFF102B5C),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'From: ${sender['username']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Offered: ${offered['name']} (${offered['category']})',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          'Requested: ${requested['name']} (${requested['category']})',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Status: $status',
                                          style: TextStyle(
                                            color:
                                                status == 'ACCEPTED'
                                                    ? Colors.greenAccent
                                                    : Colors.orangeAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (status == 'PENDING') ...[
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.check,
                                                  color: Colors.greenAccent,
                                                ),
                                                onPressed: () async {
                                                  await dataProvider
                                                      .updateRequestStatus(
                                                        authProvider.token,
                                                        req['id'],
                                                        'ACCEPTED',
                                                      );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text("Accepted"),
                                                    ),
                                                  );
                                                  await dataProvider
                                                      .fetchReceivedRequests(
                                                        authProvider.token,
                                                        int.parse(
                                                          authProvider.id!,
                                                        ),
                                                      );
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed: () async {
                                                  await dataProvider
                                                      .updateRequestStatus(
                                                        authProvider.token,
                                                        req['id'],
                                                        'REJECTED',
                                                      );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text("Rejected"),
                                                    ),
                                                  );
                                                  if (mounted) {
                                                    setState(() {
                                                      dataProvider
                                                          .receivedRequests
                                                          .removeAt(index);
                                                    });
                                                  }
                                                },
                                              ),
                                            ] else if (status ==
                                                'ACCEPTED') ...[
                                              ElevatedButton.icon(
                                                onPressed: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => ZIMKitMessageListPage(
                                                            conversationID:
                                                                generateChatId.generate(
                                                                  int.parse(
                                                                    authProvider
                                                                        .id!,
                                                                  ),
                                                                  int.parse(
                                                                    sender['id']
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                          ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.message_rounded,
                                                ),
                                                label: const Text("Chat"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF1976D2,
                                                  ),
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) => CallPage(
                                                            callID: generateCallId
                                                                .generate(
                                                                  int.parse(
                                                                    authProvider
                                                                        .id!,
                                                                  ),
                                                                  int.parse(
                                                                    sender['id']
                                                                        .toString(),
                                                                  ),
                                                                  offered['id'],
                                                                  requested['id'],
                                                                ),
                                                          ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.video_call,
                                                ),
                                                label: const Text("Join Meet"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF1976D2,
                                                  ),
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
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
