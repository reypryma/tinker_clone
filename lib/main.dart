import 'package:flutter/material.dart';
import 'package:tinker_clone/screens/auth/login_screen.dart';
import 'package:tinker_clone/screens/auth/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tinker Clone',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const RegisterScreen(),
    );
  }
}

