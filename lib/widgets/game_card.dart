import 'package:cogni_app/models/game.dart';
import 'package:cogni_app/providers/game_settings_provider.dart';
import 'package:cogni_app/screens/game_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameCard extends ConsumerWidget {
  const GameCard({super.key, required this.game});

  final GameDescriptor game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDifficulty = ref.watch(gameConfigProvider)[game.id];

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameDetailScreen(game: game),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(actionIcon(game.category), color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      game.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (selectedDifficulty != null)
                    Chip(
                      label: Text(selectedDifficulty.level),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(game.summary, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ...game.therapeuticFocus.take(2).map(
                        (focus) => Chip(
                          label: Text(focus, style: const TextStyle(fontSize: 12)),
                          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        ),
                      ),
                  Chip(
                    avatar: const Icon(Icons.settings, size: 18),
                    label: const Text('Configurar', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
