import 'package:cogni_app/bloc/session_bloc.dart';
import 'package:cogni_app/data/games.dart';
import 'package:cogni_app/models/game.dart';
import 'package:cogni_app/providers/game_settings_provider.dart';
import 'package:cogni_app/widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidedMode = ref.watch(guidedModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cogni - Juegos Terapéuticos'),
        actions: [
          IconButton(
            onPressed: () => _showQuickHelp(context),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroBanner(guidedMode: guidedMode),
          const SizedBox(height: 16),
          BlocBuilder<SessionBloc, SessionState>(
            builder: (context, state) {
              return SwitchListTile(
                value: state.guidedMode,
                onChanged: (_) {
                  context.read<SessionBloc>().add(ToggleGuidedMode());
                  ref.read(guidedModeProvider.notifier).state = !guidedMode;
                },
                title: const Text('Modo guiado para terapeutas'),
                subtitle: const Text('Control total del profesional: selecciona juegos y niveles.'),
                secondary: const Icon(Icons.supervisor_account_outlined),
              );
            },
          ),
          const SizedBox(height: 8),
          ...GameCategory.values.map((category) {
            final games = gameLibrary.where((g) => g.category == category).toList();
            return _CategorySection(category: category, games: games);
          }),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.guidedMode});

  final bool guidedMode;

  @override
  Widget build(BuildContext context) {
    final color = guidedMode
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(guidedMode ? Icons.medical_services : Icons.person_outline, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guidedMode ? 'Sesión guiada' : 'Modo libre',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  guidedMode
                      ? 'El terapeuta controla la progresión y explica cada juego al paciente.'
                      : 'Exploración autónoma para que el paciente practique sin presión.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category, required this.games});

  final GameCategory category;
  final List<GameDescriptor> games;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(actionIcon(category), color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                categoryLabels[category] ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _categoryDescription(category),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          ...games.map((game) => GameCard(game: game)),
        ],
      ),
    );
  }

  String _categoryDescription(GameCategory category) {
    switch (category) {
      case GameCategory.memoryAttention:
        return 'Memoria de trabajo, atención sostenida y selectiva.';
      case GameCategory.executiveSpeed:
        return 'Control inhibitorio, velocidad de procesamiento y reacción.';
      case GameCategory.visuomotor:
        return 'Coordinación fina, precisión y percepción visuoespacial.';
      case GameCategory.calculationPlanning:
        return 'Razonamiento numérico y planificación de pasos.';
    }
  }
}

void _showQuickHelp(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cómo usar Cogni'),
        content: const Text(
          'Selecciona una categoría, elige un juego y ajusta la dificultad según la capacidad del paciente. '
          'Puedes mantener el modo guiado activo para que el terapeuta tenga control total o cambiar a modo libre para practicar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          )
        ],
      );
    },
  );
}
