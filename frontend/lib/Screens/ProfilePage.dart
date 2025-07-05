import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../APiServices/AuthProvider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = true;
  late Map<String, dynamic> _userData;
  late Map<String, dynamic> _initialData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final data = await authProvider.getUserProfile(authProvider.id!);
      setState(() {
        _userData = data;
        _initialData = {
          'username': data['username'],
          'email': data['email'],
          'firstName': data['firstName'] ?? '',
          'lastName': data['lastName'] ?? '',
          'bio': data['bio'] ?? '',
          'location': data['location'] ?? '',
        };
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B3E),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildEditForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 50, color: Color(0xFF0D47A1)),
        ),
        const SizedBox(height: 10),
        Text(
          _userData['username'],
          style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        if (_userData['rating'] != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                _userData['rating'].toString(),
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 8),
              Text(
                '(${_userData['ratingCount'] ?? 0} reviews)',
                style: const TextStyle(color: Colors.white60),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildEditForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialData,
      child: Column(
        children: [
          _formField('username', 'Username', enabled: false),
          _formField('email', 'Email', validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Email required'),
            FormBuilderValidators.email(errorText: 'Invalid email'),
          ])),
          _formField('firstName', 'First Name'),
          _formField('lastName', 'Last Name'),
          _formField('location', 'Location'),
          _formField('bio', 'Bio', maxLines: 3),
        ],
      ),
    );
  }

  Widget _formField(String name, String label,
      {int maxLines = 1, String? Function(String?)? validator, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: FormBuilderTextField(
        name: name,
        maxLines: maxLines,
        enabled: enabled,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: enabled ? Colors.white : Colors.white60),
          filled: true,
          fillColor: const Color(0xFF102B5C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.amber),
          ),
        ),
        validator: validator ??
            FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'This field is required'),
            ]),
      ),
    );
  }


  Future<void> _saveForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        await authProvider.updateUserProfile(authProvider.id!, formData!);
        setState(() {
          _userData = {
            ..._userData,
            ...formData,
          };
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }
}
