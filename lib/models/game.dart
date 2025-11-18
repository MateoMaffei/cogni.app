import 'package:flutter/material.dart';

enum GameCategory {
  memoryAttention,
  executiveSpeed,
  visuomotor,
  calculationPlanning,
}

IconData actionIcon(GameCategory category) {
  switch (category) {
    case GameCategory.memoryAttention:
      return Icons.psychology_alt;
    case GameCategory.executiveSpeed:
      return Icons.speed;
    case GameCategory.visuomotor:
      return Icons.brush_outlined;
    case GameCategory.calculationPlanning:
      return Icons.calculate;
  }
}

class GameDifficultyOption {
  const GameDifficultyOption({
    required this.level,
    required this.description,
    required this.timeSeconds,
    required this.stimuliCount,
  });

  final String level;
  final String description;
  final int timeSeconds;
  final int stimuliCount;
}

class GameDescriptor {
  const GameDescriptor({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.objective,
    required this.therapeuticFocus,
    required this.motorFocus,
    required this.howItHelps,
    required this.difficultyOptions,
    required this.setupNotes,
    required this.instructions,
  });

  final String id;
  final String title;
  final GameCategory category;
  final String summary;
  final String objective;
  final List<String> therapeuticFocus;
  final List<String> motorFocus;
  final List<String> howItHelps;
  final List<GameDifficultyOption> difficultyOptions;
  final List<String> setupNotes;
  final List<String> instructions;
}
