import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/user_service.dart';

// Service provider
final userServiceProvider = Provider<UserService>((ref) => UserService());




