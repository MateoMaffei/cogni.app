import 'dart:async';
import 'dart:math';

import 'package:cogni_app/models/game.dart';
import 'package:flutter/material.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key, required this.game, required this.difficulty});

  final GameDescriptor game;
  final GameDifficultyOption difficulty;

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  @override
  Widget build(BuildContext context) {
    final body = switch (widget.game.id) {
      'simon' => SimonGame(difficulty: widget.difficulty),
      'parejas' => MemoryPairsGame(difficulty: widget.difficulty),
      'stroop' => StroopGame(difficulty: widget.difficulty),
      _ => ComingSoonGame(game: widget.game),
    };

    return Scaffold(
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
  final pads = const [Colors.red, Colors.blue, Colors.green, Colors.yellow];
  late List<int> _sequence;
  int _currentIndex = 0;
  int? _flashIndex;
  bool _isShowing = false;
  String _status = 'Pulsa "Mostrar secuencia" y luego repítela.';

  @override
  void initState() {
    super.initState();
    _generateSequence();
  }

  void _generateSequence() {
    final random = Random();
    final length = max(3, widget.difficulty.stimuliCount.clamp(3, 10));
    _sequence = List.generate(length, (_) => random.nextInt(pads.length));
    _currentIndex = 0;
    _status = 'Pulsa "Mostrar secuencia" y luego repítela.';
    setState(() {});
  }

  Future<void> _playSequence() async {
    if (_isShowing) return;
    setState(() {
      _isShowing = true;
      _status = 'Observa con atención.';
    });
    for (final index in _sequence) {
      setState(() => _flashIndex = index);
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _flashIndex = null);
      await Future.delayed(const Duration(milliseconds: 300));
    }
    setState(() {
      _isShowing = false;
      _status = 'Repite la secuencia.';
      _currentIndex = 0;
    });
  }

  void _onPadTap(int index) {
    if (_isShowing) return;
    if (_sequence[_currentIndex] == index) {
      if (_currentIndex == _sequence.length - 1) {
        setState(() {
          _status = '¡Excelente! Secuencia completada.';
        });
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
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(pads.length, (index) {
            final color = pads[index];
            final isActive = _flashIndex == index;
            return GestureDetector(
              onTap: () => _onPadTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isActive ? color.withOpacity(0.8) : color.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isActive
                      ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 16)]
                      : [],
                ),
                child: Center(
                  child: Text(
                    ['A', 'B', 'C', 'D'][index],
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _playSequence,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Mostrar secuencia'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _generateSequence,
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
    final deck = [...selected, ...selected]..shuffle();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_status, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            itemCount: _cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
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

class StroopGame extends StatefulWidget {
  const StroopGame({super.key, required this.difficulty});

  final GameDifficultyOption difficulty;

  @override
  State<StroopGame> createState() => _StroopGameState();
}

class _StroopGameState extends State<StroopGame> {
  final colors = const [Colors.red, Colors.green, Colors.blue, Colors.orange];
  final colorNames = const ['ROJO', 'VERDE', 'AZUL', 'NARANJA'];
  late int _targetIndex;
  late int _textIndex;
  int _score = 0;
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _setupRound();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _setupRound() {
    final random = Random();
    _targetIndex = random.nextInt(colors.length);
    final allowCongruent = widget.difficulty.level == 'Suave';
    if (allowCongruent) {
      _textIndex = _targetIndex;
    } else {
      _textIndex = random.nextInt(colors.length);
      if (_textIndex == _targetIndex) {
        _textIndex = (_textIndex + 1) % colors.length;
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
              colorNames[_textIndex],
              style: TextStyle(
                color: colors[_targetIndex],
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          children: List.generate(colors.length, (index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors[index],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              onPressed: () => _onSelect(index),
              child: Text(colorNames[index]),
            );
          }),
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
