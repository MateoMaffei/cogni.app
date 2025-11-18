import 'package:cogni_app/bloc/session_bloc.dart';
import 'package:cogni_app/data/games.dart';
import 'package:cogni_app/models/game.dart';
import 'package:cogni_app/providers/game_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
    required this.onGoHome,
    required this.onGoCategory,
    this.selectedCategory,
  });

  final VoidCallback onGoHome;
  final void Function(GameCategory) onGoCategory;
  final GameCategory? selectedCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cogni',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sesiones guiadas y juegos',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                onGoHome();
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.extension_outlined),
              title: const Text('Juegos'),
              children: [
                ...GameCategory.values.map(
                  (category) => ListTile(
                    title: Text(categoryLabels[category] ?? ''),
                    selected: selectedCategory == category,
                    onTap: () {
                      Navigator.of(context).pop();
                      onGoCategory(category);
                    },
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Configuraciones'),
              children: [
                BlocBuilder<SessionBloc, SessionState>(
                  builder: (context, state) {
                    return SwitchListTile(
                      value: state.guidedMode,
                      onChanged: (_) {
                        context.read<SessionBloc>().add(ToggleGuidedMode());
                        ref.read(guidedModeProvider.notifier).state = !state.guidedMode;
                      },
                      title: const Text('Modo guiado para terapeutas'),
                      subtitle: const Text(
                        'Activa para dirigir la sesión; desactiva para práctica libre.',
                      ),
                      secondary: const Icon(Icons.supervisor_account_outlined),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
