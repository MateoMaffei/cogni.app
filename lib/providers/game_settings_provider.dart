import 'package:cogni_app/data/games.dart';
import 'package:cogni_app/models/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameConfigNotifier
    extends StateNotifier<Map<String, GameDifficultyOption>> {
  GameConfigNotifier()
      : super({
          for (final game in gameLibrary) game.id: game.difficultyOptions.first,
        });

  void setDifficulty(String gameId, GameDifficultyOption option) {
    state = {...state, gameId: option};
  }
}

final gameConfigProvider =
    StateNotifierProvider<GameConfigNotifier, Map<String, GameDifficultyOption>>(
  (ref) => GameConfigNotifier(),
);

final guidedModeProvider = StateProvider<bool>((ref) => true);
