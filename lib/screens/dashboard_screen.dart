import 'package:cogni_app/data/games.dart';
import 'package:cogni_app/models/game.dart';
import 'package:cogni_app/widgets/app_drawer.dart';
import 'package:cogni_app/widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key, this.initialCategory});

  final GameCategory? initialCategory;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  GameCategory? _selectedCategory;

  @override
  void initState() {
    _selectedCategory = widget.initialCategory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        selectedCategory: _selectedCategory,
        onGoHome: () => setState(() => _selectedCategory = null),
        onGoCategory: (category) {
          if (!mounted) return;
          setState(() => _selectedCategory = category);
        },
      ),
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24 + MediaQuery.of(context).padding.bottom),
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _selectedCategory == null
                ? _CategoryGrid(onSelect: _handleCategorySelect)
                : _GamesForCategory(
                    category: _selectedCategory!,
                    games: gameLibrary.where((g) => g.category == _selectedCategory).toList(),
                    onBack: () => setState(() => _selectedCategory = null),
                  ),
          ),
        ],
      ),
    );
  }

  void _handleCategorySelect(GameCategory category) {
    setState(() => _selectedCategory = category);
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.onSelect});

  final void Function(GameCategory) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('category-grid'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona una categoría para ver los juegos disponibles',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int crossAxisCount = 1;
            if (width >= 1100) {
              crossAxisCount = 3;
            } else if (width >= 720) {
              crossAxisCount = 2;
            }
            return GridView.builder(
              key: const ValueKey('categories-grid-view'),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: crossAxisCount == 1 ? 16 / 7 : 16 / 10,
              ),
              itemCount: GameCategory.values.length,
              itemBuilder: (context, index) {
                final category = GameCategory.values[index];
                return _CategoryCard(
                  category: category,
                  onTap: () => onSelect(category),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final GameCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(actionIcon(category), color: Theme.of(context).colorScheme.primary),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                categoryLabels[category] ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(_categoryDescription(category), style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryDescription(GameCategory category) {
    switch (category) {
      case GameCategory.memoryAttention:
        return 'Memoria de trabajo y atención selectiva.';
      case GameCategory.executiveSpeed:
        return 'Velocidad, reacción y control inhibitorio.';
      case GameCategory.visuomotor:
        return 'Coordinación fina y percepción visuoespacial.';
      case GameCategory.calculationPlanning:
        return 'Cálculo práctico y planificación de pasos.';
    }
  }
}

class _GamesForCategory extends StatelessWidget {
  const _GamesForCategory({
    required this.category,
    required this.games,
    required this.onBack,
  });

  final GameCategory category;
  final List<GameDescriptor> games;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('games-list'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
              tooltip: 'Volver a categorías',
            ),
            const SizedBox(width: 4),
            Text(
              categoryLabels[category] ?? '',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _categoryDescription(category),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        ...games.map((game) => GameCard(game: game)),
      ],
    );
  }

  String _categoryDescription(GameCategory category) {
    switch (category) {
      case GameCategory.memoryAttention:
        return 'Trabaja memoria de trabajo, secuencias y concentración.';
      case GameCategory.executiveSpeed:
        return 'Ejercita la velocidad de procesamiento y la inhibición.';
      case GameCategory.visuomotor:
        return 'Fortalece la precisión motora y la integración visual.';
      case GameCategory.calculationPlanning:
        return 'Potencia el cálculo práctico y la organización de pasos.';
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
