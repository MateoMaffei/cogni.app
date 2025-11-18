import 'package:cogni_app/Core/theme.dart';
import 'package:cogni_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CogniApp());
}

class CogniApp extends StatelessWidget {
  const CogniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cogni',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
