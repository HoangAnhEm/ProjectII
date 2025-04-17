import 'package:client/providers/tokenProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'user_provider.dart';

// Service provider
final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

// Lấy danh sách task theo project
final projectTasksProvider = FutureProvider.family<List<Task>, int>((ref, projectId) async {
  final taskService = ref.watch(taskServiceProvider);
  final tokenAsync = await ref.watch(tokenProvider.future);

  if (tokenAsync == null) throw Exception('Unauthorized');
  return taskService.getTasksByProject(tokenAsync, projectId);
});

// Lấy task theo ID
final taskProvider = FutureProvider.family<Task, int>((ref, taskId) async {
  final taskService = ref.watch(taskServiceProvider);
  final tokenAsync = await ref.watch(tokenProvider.future);

  if (tokenAsync == null) throw Exception('Unauthorized');
  return taskService.getTaskById(tokenAsync, taskId);
});

// StateNotifier cho thao tác với 1 task (tạo, cập nhật, xóa)
class TaskActionNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskService _taskService;
  final String token;

  TaskActionNotifier(this._taskService, this.token) : super(const AsyncValue.data(null));

  Future<void> createTask(Map<String, dynamic> taskData) async {
    state = const AsyncValue.loading();
    try {
      await _taskService.createTask(token, taskData);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTask(int taskId, Map<String, dynamic> taskData) async {
    state = const AsyncValue.loading();
    try {
      await _taskService.updateTask(token, taskId, taskData);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTask(int taskId) async {
    state = const AsyncValue.loading();
    try {
      await _taskService.deleteTask(token, taskId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Provider cho thao tác với task (cần truyền token)
final taskActionNotifierProvider = StateNotifierProvider.family<TaskActionNotifier, AsyncValue<void>, String>(
      (ref, token) => TaskActionNotifier(ref.watch(taskServiceProvider), token),
);
