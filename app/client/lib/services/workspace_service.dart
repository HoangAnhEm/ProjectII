import 'dart:convert';
import 'package:client/services/token_service.dart';
import 'package:http/http.dart' as http;
import '../models/workspace.dart';
import '../utils/api_constants.dart';

class WorkspaceService {
  final String baseUrl = 'http://localhost:3000/v1/workspace';

  Future<List<Workspace>> getUserWorkspaces(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/workspaces'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((json) => Workspace.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get workspaces: ${response.body}');
    }
  }

  Future<Workspace> getWorkspaceById(String token, int workspaceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/workspaces/$workspaceId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Workspace.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to get workspace: ${response.body}');
    }
  }

  Future<Workspace> createWorkspace(String token, Map<String, dynamic> workspace) async {
    final response = await http.post(
      Uri.parse('$baseUrl/workspaces'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(workspace),
    );

    if (response.statusCode == 201) {
      return Workspace.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to create workspace: ${response.body}');
    }
  }

  Future<Workspace> updateWorkspace(String token, int workspaceId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/workspaces/$workspaceId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return Workspace.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to update workspace: ${response.body}');
    }
  }

  Future<List<WorkspaceUser>> getWorkspaceMembers(String token, int workspaceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/workspaces/$workspaceId/members'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((json) => WorkspaceUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get workspace members: ${response.body}');
    }
  }
}
