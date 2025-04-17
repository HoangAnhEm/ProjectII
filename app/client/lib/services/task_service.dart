import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../utils/api_constants.dart';

class TaskService {
  final String baseUrl = 'http://localhost:3000/v1/task';

  Future<List<Task>> getTasksByProject(String token, int projectId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/projects/$projectId/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get tasks: ${response.body}');
    }
  }

  Future<Task> getTaskById(String token, int taskId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to get task: ${response.body}');
    }
  }

  Future<Task> createTask(String token, Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(taskData),
    );
    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  Future<Task> updateTask(String token, int taskId, Map<String, dynamic> taskData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(taskData),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to update task: ${response.body}');
    }
  }

  Future<void> deleteTask(String token, int taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete task: ${response.body}');
    }
  }
}
