import 'package:cogni_app/widgets/custom_button.dart';
import 'package:cogni_app/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleLogin(BuildContext context) {
    debugPrint('Login button pressed');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Intentando iniciar sesión...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo (comentado para reemplazar luego)
              Image.asset('assets/Cogni_Logo.png', height: 100),
              const SizedBox(height: 20),

              Text(
                'Bienvenido a Cogni',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),

              const CustomInput(label: 'Usuario'),
              const SizedBox(height: 20),
              const CustomInput(label: 'Contraseña', isPassword: true),
              const SizedBox(height: 30),

              CustomButton(
                text: 'Iniciar Sesión',
                onPressed: () => _handleLogin(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
