import 'dart:async';
import 'dart:math';

import 'package:cogni_app/models/game.dart';
import 'package:cogni_app/screens/dashboard_screen.dart';
import 'package:cogni_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key, required this.game, required this.difficulty});

  final GameDescriptor game;
  final GameDifficultyOption difficulty;

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  void _goToCategory(GameCategory category) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DashboardScreen(initialCategory: category)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = switch (widget.game.id) {
      'simon' => SimonGame(difficulty: widget.difficulty),
      'parejas' => MemoryPairsGame(difficulty: widget.difficulty),
      'stroop' => StroopGame(difficulty: widget.difficulty),
      _ => ComingSoonGame(game: widget.game),
    };

    return Scaffold(
      drawer: AppDrawer(
        selectedCategory: widget.game.category,
        onGoHome: _goHome,
        onGoCategory: _goToCategory,
      ),
      appBar: AppBar(
        title: Text(widget.game.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Chip(label: Text(widget.difficulty.level)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: body,
        ),
      ),
    );
  }
}

class SimonGame extends StatefulWidget {
  const SimonGame({super.key, required this.difficulty});

  final GameDifficultyOption difficulty;

  @override
  State<SimonGame> createState() => _SimonGameState();
}

class _SimonGameState extends State<SimonGame> {
  final allPads = const [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
  ];
  late List<Color> _pads;
  late List<int> _sequence;
  int _currentIndex = 0;
  int? _flashIndex;
  bool _isShowing = false;
  String _status = 'Pulsa "Mostrar secuencia" y luego repítela.';

  @override
  void initState() {
    super.initState();
    _configurePads();
    _generateSequence();
  }

  void _configurePads() {
    final targetCount = min(
      allPads.length,
      max(4, (widget.difficulty.stimuliCount / 1.5).ceil()),
    );
    _pads = allPads.take(targetCount).toList();
  }

  void _generateSequence({bool autoPlay = false}) {
    final random = Random();
    final length = max(3, widget.difficulty.stimuliCount.clamp(3, 10));
    _sequence = List.generate(length, (_) => random.nextInt(_pads.length));
    _currentIndex = 0;
    _status = 'Pulsa "Mostrar secuencia" y luego repítela.';
    _isShowing = false;
    setState(() {});
    if (autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _playSequence());
    }
  }

  Future<void> _playSequence() async {
    if (_isShowing) return;
    setState(() {
      _isShowing = true;
      _status = 'Observa con atención.';
    });
    for (final index in _sequence) {
      setState(() => _flashIndex = index);
      await Future.delayed(const Duration(milliseconds: 650));
      setState(() => _flashIndex = null);
      await Future.delayed(const Duration(milliseconds: 280));
    }
    setState(() {
      _isShowing = false;
      _status = 'Repite la secuencia.';
      _currentIndex = 0;
    });
  }

  Future<void> _flashTap(int index) async {
    setState(() => _flashIndex = index);
    await Future.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;
    setState(() => _flashIndex = null);
  }

  void _onPadTap(int index) {
    if (_isShowing) return;
    _flashTap(index);
    if (_sequence[_currentIndex] == index) {
      if (_currentIndex == _sequence.length - 1) {
        setState(() {
          _status = '¡Excelente! Se muestra una nueva secuencia.';
        });
        _generateSequence(autoPlay: true);
      } else {
        setState(() {
          _currentIndex += 1;
          _status = 'Sigue, faltan ${_sequence.length - _currentIndex} pasos.';
        });
      }
    } else {
      setState(() {
        _status = 'Incorrecto. Vuelve a ver la secuencia y reintenta.';
        _currentIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_status, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = max(2, sqrt(_pads.length).ceil());
              return GridView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: _pads.length,
                itemBuilder: (context, index) {
                  final color = _pads[index];
                  final isActive = _flashIndex == index;
                  return GestureDetector(
                    onTap: () => _onPadTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      decoration: BoxDecoration(
                        color: isActive ? color : color.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.65),
                                  blurRadius: 28,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _playSequence,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Mostrar secuencia'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => _generateSequence(autoPlay: true),
              icon: const Icon(Icons.refresh),
              label: const Text('Nueva secuencia'),
            ),
          ],
        ),
      ],
    );
  }
}

class MemoryPairsGame extends StatefulWidget {
  const MemoryPairsGame({super.key, required this.difficulty});

  final GameDifficultyOption difficulty;

  @override
  State<MemoryPairsGame> createState() => _MemoryPairsGameState();
}

class _MemoryPairsGameState extends State<MemoryPairsGame> {
  late List<_CardItem> _cards;
  _CardItem? _firstSelected;
  int _pairsFound = 0;
  String _status = 'Toca dos cartas y busca las parejas.';

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    const icons = [
      Icons.favorite,
      Icons.star,
      Icons.accessibility_new,
      Icons.brush,
      Icons.face,
      Icons.headset,
      Icons.lightbulb,
      Icons.emoji_nature,
    ];
    final neededPairs = (widget.difficulty.stimuliCount ~/ 2).clamp(2, 6);
    final selected = icons.take(neededPairs).toList();
    final deck = [...selected, ...selected];
    final random = Random();
    for (int i = 0; i < 5; i++) {
      deck.shuffle(random);
    }
    final columns = _gridColumns(deck.length);
    int attempts = 0;
    while (_hasAdjacentPairs(deck, columns) && attempts < 12) {
      deck.shuffle(random);
      attempts++;
    }
    _cards = deck
        .asMap()
        .entries
        .map((entry) => _CardItem(icon: entry.value, id: entry.key))
        .toList();
    _firstSelected = null;
    _pairsFound = 0;
    _status = 'Toca dos cartas y busca las parejas.';
    setState(() {});
  }

  void _onCardTap(_CardItem card) {
    if (card.isMatched || card.isRevealed) return;
    setState(() => card.isRevealed = true);
    if (_firstSelected == null) {
      _firstSelected = card;
      return;
    }

    if (_firstSelected!.icon == card.icon) {
      setState(() {
        card.isMatched = true;
        _firstSelected!.isMatched = true;
        _pairsFound += 1;
        _status = _pairsFound == _cards.length ~/ 2
            ? '¡Todas las parejas encontradas!'
            : '¡Bien! Sigue buscando.';
        _firstSelected = null;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 700), () {
        setState(() {
          card.isRevealed = false;
          _firstSelected?.isRevealed = false;
          _status = 'No coinciden, inténtalo de nuevo.';
          _firstSelected = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = _gridColumns(_cards.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_status, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            itemCount: _cards.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final card = _cards[index];
              return GestureDetector(
                onTap: () => _onCardTap(card),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: card.isMatched
                        ? Colors.green.shade200
                        : card.isRevealed
                            ? Colors.blue.shade100
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: card.isMatched || card.isRevealed
                        ? Icon(card.icon, size: 36, color: Colors.blueGrey.shade800)
                        : const Icon(Icons.help_outline, color: Colors.white70, size: 30),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.replay_outlined),
              label: const Text('Reiniciar'),
            ),
            const SizedBox(width: 12),
            Text('Parejas: $_pairsFound / ${_cards.length ~/ 2}'),
          ],
        ),
      ],
    );
  }
}

class _CardItem {
  _CardItem({required this.icon, required this.id});

  final IconData icon;
  final int id;
  bool isRevealed = false;
  bool isMatched = false;
}

int _gridColumns(int length) {
  if (length <= 6) return 2;
  if (length <= 12) return 3;
  return 4;
}

bool _hasAdjacentPairs(List<IconData> deck, int columns) {
  for (int i = 0; i < deck.length; i++) {
    if ((i % columns) != columns - 1 && deck[i] == deck[i + 1]) {
      return true;
    }
    if (i + columns < deck.length && deck[i] == deck[i + columns]) {
      return true;
    }
  }
  return false;
}

class StroopGame extends StatefulWidget {
  const StroopGame({super.key, required this.difficulty});

  final GameDifficultyOption difficulty;

  @override
  State<StroopGame> createState() => _StroopGameState();
}

class _StroopGameState extends State<StroopGame> {
  final availableColors = const [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.brown,
  ];
  final availableNames = const [
    'ROJO',
    'VERDE',
    'AZUL',
    'NARANJA',
    'MORADO',
    'TURQUESA',
    'ROSA',
    'MARRÓN',
  ];
  late List<Color> _colors;
  late List<String> _colorNames;
  late int _targetIndex;
  late int _textIndex;
  int _score = 0;
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _configurePalette();
    _setupRound();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _configurePalette() {
    final desired = max(4, (widget.difficulty.stimuliCount / 2).ceil());
    final count = min(availableColors.length, desired);
    _colors = availableColors.take(count).toList();
    _colorNames = availableNames.take(count).toList();
  }

  void _setupRound() {
    final random = Random();
    _targetIndex = random.nextInt(_colors.length);
    final allowCongruent = widget.difficulty.level == 'Suave';
    if (allowCongruent) {
      _textIndex = _targetIndex;
    } else {
      _textIndex = random.nextInt(_colors.length);
      if (_textIndex == _targetIndex) {
        _textIndex = (_textIndex + 1) % _colors.length;
      }
    }
    setState(() {});
  }

  void _startTimer() {
    _remainingSeconds = widget.difficulty.timeSeconds == 0
        ? 999 // sin límite práctico
        : widget.difficulty.timeSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _remainingSeconds -= 1);
    });
  }

  void _onSelect(int index) {
    if (_remainingSeconds <= 0) return;
    if (index == _targetIndex) {
      _score += 1;
      _setupRound();
    } else {
      _score = max(0, _score - 1);
      _setupRound();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Puntaje: $_score', style: Theme.of(context).textTheme.titleMedium),
            Text(
              widget.difficulty.timeSeconds == 0
                  ? 'Sin límite'
                  : 'Tiempo: $_remainingSeconds s',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _colorNames[_textIndex],
              style: TextStyle(
                color: _colors[_targetIndex],
                fontSize: 44,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 700;
            final crossAxisCount = isTablet
                ? 3
                : constraints.maxWidth > 480
                    ? 2
                    : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isTablet ? 2.8 : 2.2,
              ),
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colors[index],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () => _onSelect(index),
                  child: Text(
                    _colorNames[index],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class ComingSoonGame extends StatelessWidget {
  const ComingSoonGame({super.key, required this.game});

  final GameDescriptor game;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.extension_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Próximamente: ${game.title}',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text('Este juego aún no está implementado en la demo.'),
        ],
      ),
    );
  }
}
