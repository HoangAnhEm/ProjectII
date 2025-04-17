import 'package:client/providers/tokenProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workspace.dart';
import '../services/workspace_service.dart';
import 'user_provider.dart';

// Service provider
final workspaceServiceProvider = Provider<WorkspaceService>((ref) => WorkspaceService());

// User workspaces provider
final userWorkspacesProvider = FutureProvider<List<Workspace>>((ref) async {
  final workspaceService = ref.watch(workspaceServiceProvider);
  final tokenAsync = await ref.watch(tokenProvider.future);

  if (tokenAsync == null) {
    throw Exception('Unauthorized');
  }

  return workspaceService.getUserWorkspaces(tokenAsync);
});

// Single workspace provider
final workspaceProvider = FutureProvider.family<Workspace, int>((ref, workspaceId) async {
  final workspaceService = ref.watch(workspaceServiceProvider);
  final tokenAsync = await ref.watch(tokenProvider.future);

  if (tokenAsync == null) {
    throw Exception('Unauthorized');
  }

  return workspaceService.getWorkspaceById(tokenAsync, workspaceId);
});

// Workspace members provider
final workspaceMembersProvider = FutureProvider.family<List<WorkspaceUser>, int>((ref, workspaceId) async {
  final workspaceService = ref.watch(workspaceServiceProvider);
  final tokenAsync = await ref.watch(tokenProvider.future);

  if (tokenAsync == null) {
    throw Exception('Unauthorized');
  }

  return workspaceService.getWorkspaceMembers(tokenAsync, workspaceId);
});

// Current workspace provider
class CurrentWorkspaceNotifier extends StateNotifier<Workspace?> {
  CurrentWorkspaceNotifier() : super(null);

  void setCurrentWorkspace(Workspace workspace) {
    state = workspace;
  }

  void clearCurrentWorkspace() {
    state = null;
  }
}

final currentWorkspaceProvider = StateNotifierProvider<CurrentWorkspaceNotifier, Workspace?>((ref) {
  return CurrentWorkspaceNotifier();
});
