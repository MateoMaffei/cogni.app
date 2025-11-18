import 'package:cogni_app/bloc/session_bloc.dart';
import 'package:cogni_app/data/games.dart';
import 'package:cogni_app/models/game.dart';
import 'package:cogni_app/providers/game_settings_provider.dart';
import 'package:cogni_app/widgets/app_drawer.dart';
import 'package:cogni_app/widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final guidedMode = ref.watch(guidedModeProvider);

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
          const SizedBox(height: 12),
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
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...GameCategory.values.map(
              (category) => _CategoryCard(
                category: category,
                onTap: () => onSelect(category),
              ),
            ),
          ],
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
    return SizedBox(
      width: 200,
      child: Card(
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
