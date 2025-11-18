import 'package:cogni_app/bloc/session_bloc.dart';
import 'package:cogni_app/models/game.dart';
import 'package:cogni_app/providers/game_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameDetailScreen extends ConsumerWidget {
  const GameDetailScreen({super.key, required this.game});

  final GameDescriptor game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(gameConfigProvider)[game.id] ??
        game.difficultyOptions.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(
            icon: Icons.info_outline,
            title: 'Objetivo terapéutico',
          ),
          Text(game.objective, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),
          _TagsBlock(
            label: 'Enfoque cognitivo',
            items: game.therapeuticFocus,
            color: Theme.of(context).colorScheme.primary,
          ),
          _TagsBlock(
            label: 'Enfoque motor',
            items: game.motorFocus,
            color: Theme.of(context).colorScheme.secondary,
          ),
          _SectionHeader(icon: Icons.flag_outlined, title: 'Cómo ayuda'),
          ...game.howItHelps.map((item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle_outline),
                title: Text(item),
              )),
          const SizedBox(height: 8),
          _SectionHeader(icon: Icons.settings_suggest_outlined, title: 'Configura la dificultad'),
          Row(
            children: [
              const Icon(Icons.volunteer_activism_outlined, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: BlocBuilder<SessionBloc, SessionState>(
                  builder: (context, state) {
                    return Text(
                      state.guidedMode
                          ? 'Modo guiado activo para terapeutas'
                          : 'Modo libre para práctica individual',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[700]),
                    );
                  },
                ),
              ),
              Switch(
                value: context.read<SessionBloc>().state.guidedMode,
                onChanged: (_) => context.read<SessionBloc>().add(ToggleGuidedMode()),
              ),
            ],
          ),
          DropdownButtonFormField<GameDifficultyOption>(
            value: difficulty,
            decoration: const InputDecoration(labelText: 'Nivel'),
            items: game.difficultyOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text('${option.level} • ${option.description}'),
                    ))
                .toList(),
            onChanged: (option) {
              if (option != null) {
                ref.read(gameConfigProvider.notifier).setDifficulty(game.id, option);
              }
            },
          ),
          const SizedBox(height: 8),
          _DifficultyChips(
            options: game.difficultyOptions,
            selected: difficulty,
            gameId: game.id,
          ),
          const SizedBox(height: 16),
          _SectionHeader(icon: Icons.rule, title: 'Instrucciones'),
          ...game.instructions.map((step) => ListTile(
                leading: const Icon(Icons.play_arrow),
                title: Text(step),
              )),
          const SizedBox(height: 8),
          _SectionHeader(icon: Icons.health_and_safety_outlined, title: 'Recomendaciones para el terapeuta'),
          ...game.setupNotes.map((note) => ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: Text(note),
              )),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Iniciar práctica guiada'),
            onPressed: () => _showPracticePlan(context, difficulty),
          ),
        ],
      ),
    );
  }

  void _showPracticePlan(BuildContext context, GameDifficultyOption difficulty) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.route, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Plan rápido',
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                ),
                Chip(label: Text(difficulty.level)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Tiempo sugerido: ${difficulty.timeSeconds > 0 ? '${difficulty.timeSeconds} seg' : 'sin límite'}',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            Text(
              'Número de estímulos: ${difficulty.stimuliCount}',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            const Text('Consejos rápidos:'),
            const SizedBox(height: 8),
            const Text('• Explica la consigna lentamente y demuestra un ejemplo.'),
            const Text('• Ajusta la velocidad según el nivel seleccionado.'),
            const Text('• Registra comentarios cualitativos del paciente (no se guardan datos).'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Listo, comenzar juego'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TagsBlock extends StatelessWidget {
  const _TagsBlock({required this.label, required this.items, required this.color});

  final String label;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: items
                .map(
                  (item) => Chip(
                    backgroundColor: color.withOpacity(0.12),
                    label: Text(item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DifficultyChips extends ConsumerWidget {
  const _DifficultyChips({
    required this.options,
    required this.selected,
    required this.gameId,
  });

  final List<GameDifficultyOption> options;
  final GameDifficultyOption selected;
  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      children: options
          .map(
            (option) => ChoiceChip(
              label: Text(option.level),
              selected: selected == option,
              onSelected: (_) => ref
                  .read(gameConfigProvider.notifier)
                  .setDifficulty(gameId, option),
            ),
          )
          .toList(),
    );
  }
}
