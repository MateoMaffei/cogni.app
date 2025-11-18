import 'package:cogni_app/models/game.dart';
import 'package:cogni_app/providers/game_settings_provider.dart';
import 'package:cogni_app/screens/dashboard_screen.dart';
import 'package:cogni_app/screens/game_play_screen.dart';
import 'package:cogni_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameDetailScreen extends ConsumerWidget {
  const GameDetailScreen({super.key, required this.game});

  final GameDescriptor game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(gameConfigProvider)[game.id] ??
        game.difficultyOptions.first;

    return Scaffold(
      drawer: AppDrawer(
        selectedCategory: game.category,
        onGoHome: () => _goHome(context),
        onGoCategory: (category) => _goToCategory(context, category),
      ),
      appBar: AppBar(
        title: Text(game.title),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 28 + MediaQuery.of(context).padding.bottom),
          children: [
            _InfoCard(
              icon: Icons.info_outline,
              title: 'Objetivo terapéutico',
              child: Text(game.objective, style: Theme.of(context).textTheme.bodyLarge),
            ),
            _InfoCard(
              icon: Icons.extension_outlined,
              title: 'Enfoques',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TagsBlock(
                    label: 'Enfoque cognitivo',
                    items: game.therapeuticFocus,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 6),
                  _TagsBlock(
                    label: 'Enfoque motor',
                    items: game.motorFocus,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
            _InfoCard(
              icon: Icons.flag_outlined,
              title: 'Cómo ayuda',
              child: Column(
                children: game.howItHelps
                    .map(
                      (item) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(item),
                      ),
                    )
                    .toList(),
              ),
            ),
            _InfoCard(
              icon: Icons.settings_suggest_outlined,
              title: 'Configura la dificultad',
              child: Column(
                children: [
                  DropdownButtonFormField<GameDifficultyOption>(
                    isExpanded: true,
                    value: difficulty,
                    decoration: const InputDecoration(labelText: 'Nivel'),
                    items: game.difficultyOptions
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(
                                '${option.level} • ${option.description}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: (option) {
                      if (option != null) {
                        ref.read(gameConfigProvider.notifier).setDifficulty(game.id, option);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _DifficultyChips(
                    options: game.difficultyOptions,
                    selected: difficulty,
                    gameId: game.id,
                  ),
                ],
              ),
            ),
            _InfoCard(
              icon: Icons.rule,
              title: 'Instrucciones',
              child: Column(
                children: game.instructions
                    .map(
                      (step) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.play_arrow),
                        title: Text(step),
                      ),
                    )
                    .toList(),
              ),
            ),
            _InfoCard(
              icon: Icons.health_and_safety_outlined,
              title: 'Recomendaciones para el terapeuta',
              child: Column(
                children: game.setupNotes
                    .map(
                      (note) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.lightbulb_outline),
                        title: Text(note),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Iniciar práctica'),
                  onPressed: () => _startPractice(context, difficulty),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startPractice(BuildContext context, GameDifficultyOption difficulty) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GamePlayScreen(game: game, difficulty: difficulty),
      ),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  void _goToCategory(BuildContext context, GameCategory category) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DashboardScreen(initialCategory: category)),
      (route) => false,
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.child});

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
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
