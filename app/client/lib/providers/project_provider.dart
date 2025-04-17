import 'package:client/providers/tokenProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../services/project_service.dart';
import 'user_provider.dart';
import 'workspace_provider.dart';

// Service provider
final projectServiceProvider = Provider<ProjectService>((ref) => ProjectService());

// Workspace projects provider
final workspaceProjectsProvider = FutureProvider.family<List<Project>, int>((ref, workspaceId) async {
  final projectService = ref.watch(projectServiceProvider);
  final tokenAsync = await ref.watch(tokenProvider.future);

  if (tokenAsync == null) {
    throw Exception('Unauthorized');
  }

  return projectService.getWorkspaceProjects(tokenAsync, workspaceId);
});

// Current workspace projects provider (auto-refresh when current workspace changes)
final currentWorkspaceProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final currentWorkspace = ref.watch(currentWorkspaceProvider);
  final projectService = ref.watch(projectServiceProvider);
  final tokenAsync = await ref.watch(tokenProvider.future);

  if (tokenAsync == null || currentWorkspace == null) {
    return [];
  }

  return projectService.getWorkspaceProjects(tokenAsync, currentWorkspace.workspaceId);
});

// Single project provider
final projectProvider = FutureProvider.family<Project, int>((ref, projectId) async {
  final projectService = ref.watch(projectServiceProvider);
  final tokenAsync = await ref.watch(tokenProvider.future);

  if (tokenAsync == null) {
    throw Exception('Unauthorized');
  }

  return projectService.getProjectById(tokenAsync, projectId);
});

// Current project provider
class CurrentProjectNotifier extends StateNotifier<Project?> {
  CurrentProjectNotifier() : super(null);

  void setCurrentProject(Project project) {
    state = project;
  }

  void clearCurrentProject() {
    state = null;
  }
}

final currentProjectProvider = StateNotifierProvider<CurrentProjectNotifier, Project?>((ref) {
  return CurrentProjectNotifier();
});
