import 'package:client/layout/user_layout.dart';
import 'package:client/page/convert_page.dart';
import 'package:client/page/my_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'page/landing_page.dart';
import 'page/login_page.dart';
import 'page/signup_page.dart';
import 'page/home_page.dart';
import 'page/test.dart';

void main() {
  runApp(
     ProviderScope(
      child: TaskFlowApp(),
    )
  );
}

class TaskFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => LandingPage(),
        '/login': (_) => LoginPage(),
        '/signup': (_) => SignupPage(),
        '/home': (_) => HomePage(),
        '/myTask': (_) => MyTask(),
        '/calendar': (_) => UserLayout(child: Container(), label: 'Calendar'),
        '/dashboard': (_) => UserLayout(child: Container(), label: 'Dashboard'),
        '/timesheet': (_) => UserLayout(child: Container(), label: 'Timesheet'),
        '/convert': (_) => UserLayout(child: MeetingMinutesDropScreen(), label: 'Convert'),
        '/more': (_) => UserLayout(child: Container(), label: 'More'),
      },
    );
  }
}

