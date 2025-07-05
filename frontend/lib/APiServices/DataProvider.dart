import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'APIBaseUrl.dart';

class DataProvider with ChangeNotifier{

  final String baseUrl = APIBaseUrl.baseUrl;

  List<dynamic> _skills = [];

  List<dynamic> get skills => _skills;


  List<dynamic> _offeredskills = [];

  List<dynamic> get offeredskills => _offeredskills;

  List<dynamic> _sentRequests = [];

  List<dynamic> get sentRequests => _sentRequests;

  List<dynamic> _receivedRequests = [];

  List<dynamic> get receivedRequests => _receivedRequests;

  //General list of skills for adding a new skill of current user
  Future<void> fetchAllSkills(String? token) async {
    final response = await http.get(
      Uri.parse('${baseUrl}getSkills'),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      _skills = jsonDecode(response.body);
      notifyListeners();
    }else{
      print('Failed to fetch data');
      throw Exception('Failed to fetch data');
    }
  }


  //to fetch current user skills by his/her id
  Future<List<dynamic>> fetchAllSkillsById(String? token, int id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}getUserSkill/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      print('Failed to fetch data');
      throw Exception('Failed to fetch data');
    }
  }


  //to fetch available skills offered by different users except current user id
  Future<void> fetchAllSkillsByDifferentUsers(String? token, int id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}getUserSkillExceptId/$id'),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      _offeredskills = jsonDecode(response.body);
      notifyListeners();
    }else{
      print('Failed to fetch data');
      throw Exception('Failed to fetch data');
    }
  }



  //to add skill for current user
  Future<void> addSkillForCurrentUser(String? token, Map<String, dynamic> newSkill) async {
    final response = await http.post(
      Uri.parse('${baseUrl}addUserSkill'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(newSkill),
    );

    if (response.statusCode == 200) {
      await fetchAllSkills(token); // Refresh after adding
    } else {
      throw Exception("Failed to add skill");
    }
  }

  Future<void> sendExchangeRequest(String? token, Map<String, Object?> requestData) async {
    final response = await http.post(
      Uri.parse('${baseUrl}exchangerequest'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      await fetchAllSkills(token); // Refresh after adding
    } else {
      throw Exception("Failed to add skill");
    }

  }

  Future<void> fetchSentRequests(String? token, int id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}sentrequest/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _sentRequests = jsonDecode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load sent requests');
    }
  }

  Future<void> fetchReceivedRequests(String? token, int id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}receivedrequest/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _receivedRequests = jsonDecode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load received requests');
    }
  }

  Future<void> updateRequestStatus(String? token, int id, String status) async {
    final response = await http.put(
      Uri.parse('${baseUrl}updatestatus/$id?status=$status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update request status');
    }
  }


}