import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../APiServices/AuthProvider.dart';
import '../APiServices/DataProvider.dart';

class ExchangeSkillScreen extends StatefulWidget {
  final int receiverUserId;
  final int requestedSkillId;
  final String description;

  const ExchangeSkillScreen({
    super.key,
    required this.receiverUserId,
    required this.requestedSkillId,
    required this.description,
  });

  @override
  State<ExchangeSkillScreen> createState() => _ExchangeSkillScreenState();
}

class _ExchangeSkillScreenState extends State<ExchangeSkillScreen> {
  int? _selectedOfferedSkillId;
  Map<String, dynamic>? _receiverProfile;
  Map<String, dynamic>? _requestedSkill;

  @override
  void initState() {
    super.initState();
    _loadReceiverData();
  }

  Future<void> _loadReceiverData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final user = await authProvider.getUserProfile(widget.receiverUserId.toString());

    final userSkills = await dataProvider.fetchAllSkillsById(
        authProvider.token, widget.receiverUserId);

    final skill = userSkills.firstWhere(
          (s) => s['skill']['id'] == widget.requestedSkillId,
      orElse: () => {},
    );

    setState(() {
      _receiverProfile = user;
      _requestedSkill = skill['skill'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Propose Skill Exchange", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D1B3E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _receiverProfile == null
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : FutureBuilder<List<dynamic>>(
          future: dataProvider.fetchAllSkillsById(authProvider.token, int.parse(authProvider.id!)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
              );
            }

            final userSkills = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildReceiverInfo(),
                  const SizedBox(height: 20),
                  const Text("Select a skill you can offer:",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: _selectedOfferedSkillId,
                      hint: const Text("Choose your skill", style: TextStyle(color: Colors.white)),
                      dropdownColor: Colors.black,
                      underline: const SizedBox(),
                      iconEnabledColor: Colors.white,
                      items: userSkills.map((skill) {
                        return DropdownMenuItem<int>(
                          value: skill['skill']['id'],
                          child: Text(skill['skill']['name'], style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOfferedSkillId = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text("Send Request"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      if (_selectedOfferedSkillId == null) return;

                      Map<String, dynamic> requestData = {
                        "user1": {"id": authProvider.id},
                        "user2": {"id": widget.receiverUserId},
                        "skillOffered": {"id": _selectedOfferedSkillId},
                        "skillRequested": {"id": widget.requestedSkillId},
                        "status": "PENDING"
                      };

                      try {
                        await dataProvider.sendExchangeRequest(authProvider.token, requestData);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Exchange request sent")),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to send request")),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReceiverInfo() {
    final user = _receiverProfile!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Receiver Details", style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _infoRow("Name", "${user['firstName'] ?? ''} ${user['lastName'] ?? 'Not Specified'}"),
        _infoRow("Email", user['email']),
        _infoRow("Location", user['location'] ?? 'Not specified'),
        _infoRow("Bio", user['bio'] ?? 'No bio'),
        _infoRow("Rating", "${user['rating']?.toStringAsFixed(1) ?? '0.0'} (${user['ratingCount'] ?? 0} reviews)"),
        if (_requestedSkill != null)
          _infoRow("Skill Requested", "${_requestedSkill!['name']} (${_requestedSkill!['category']})"),
        _infoRow("Description", widget.description),
        const Divider(color: Colors.white54, thickness: 1, height: 30),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 20)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 20))),
        ],
      ),
    );
  }
}
