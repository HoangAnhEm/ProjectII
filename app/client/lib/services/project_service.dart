import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../utils/api_constants.dart';

class ProjectService {
  final String baseUrl = 'http://localhost:3000/v1/project';

  Future<List<Project>> getWorkspaceProjects(String token, int workspaceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/workspaces/$workspaceId/projects'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get projects: ${response.body}');
    }
  }

  Future<Project> getProjectById(String token, int projectId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to get project: ${response.body}');
    }
  }

  Future<Project> createProject(String token, Map<String, dynamic> project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(project),
    );

    if (response.statusCode == 201) {
      return Project.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to create project: ${response.body}');
    }
  }

  Future<Project> updateProject(String token, int projectId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/projects/$projectId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to update project: ${response.body}');
    }
  }
}
