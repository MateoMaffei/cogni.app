import 'package:cogni_app/Core/theme.dart';
import 'package:cogni_app/bloc/session_bloc.dart';
import 'package:cogni_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: CogniApp()));
}

class CogniApp extends StatelessWidget {
  const CogniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SessionBloc()),
      ],
      child: MaterialApp(
        title: 'Cogni',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
