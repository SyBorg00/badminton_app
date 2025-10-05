import 'package:flutter/material.dart';
import 'package:badminton_app/model/players.dart';

class PlayerLevelWidget extends StatefulWidget {
  final void Function(PlayerLevel level) onSliderChanged;
  final PlayerLevel? level;
  const PlayerLevelWidget({
    super.key,
    required this.onSliderChanged,
    this.level,
  });

  @override
  State<PlayerLevelWidget> createState() => _PlayerLevelWidgetState();
}

class _PlayerLevelWidgetState extends State<PlayerLevelWidget> {
  late final List<String> _rankLabels;
  late final List<String> _strengthLabels;
  late final List<(PlayerRank, PlayerStrength?)> _levelPair;

  //^ COMBINATION OF PLAYER RANK AND STRENGTH

  late PlayerLevel playerLevel;
  // ^ the data that will be submitted to the player_management widget

  RangeValues _currentRange = const RangeValues(0, 3);

  @override
  void initState() {
    super.initState();
    _rankLabels = [];
    _strengthLabels = [];
    _levelPair = [];

    for (var rank in PlayerRank.values) {
      if (rank == PlayerRank.open) {
        _levelPair.add((rank, null));
        _rankLabels.add(_rankLabel(rank));
        _strengthLabels.add('');
      } else {
        for (var strength in PlayerStrength.values) {
          _levelPair.add((rank, strength));
          _rankLabels.add("${_rankLabel(rank)} - ${_strengthLabel(strength)}");
          _strengthLabels.add(_strengthLabel(strength));
        }
      }
    }
    if (widget.level != null) {
      final startIndex = _levelPair.indexWhere(
        (pair) =>
            pair.$1 == widget.level!.rank.start &&
            (pair.$2 ?? PlayerStrength.strong) ==
                (widget.level!.strength.start),
      );
      final endIndex = _levelPair.indexWhere(
        (pair) =>
            pair.$1 == widget.level!.rank.end &&
            (pair.$2 ?? PlayerStrength.strong) == (widget.level!.strength.end),
      );

      if (startIndex != -1 && endIndex != -1) {
        _currentRange = RangeValues(startIndex.toDouble(), endIndex.toDouble());
        playerLevel = widget.level!;
      }
    }
  }

  //#region for slider display configuration
  String _rankLabel(PlayerRank rank) {
    switch (rank) {
      case PlayerRank.intermediate:
        return "Intermediate";
      case PlayerRank.levelG:
        return "Level G";
      case PlayerRank.levelF:
        return "Level F";
      case PlayerRank.levelE:
        return "Level E";
      case PlayerRank.levelD:
        return "Level D";
      case PlayerRank.open:
        return "Open";
    }
  }

  String _strengthLabel(PlayerStrength strength) {
    switch (strength) {
      case PlayerStrength.weak:
        return "W";
      case PlayerStrength.mid:
        return "M";
      case PlayerStrength.strong:
        return "S";
    }
  }

  List<Widget> _buildRankLabels() {
    final labels = <Widget>[];
    final ranks = PlayerRank.values;

    for (var rank in ranks) {
      final label = Text(
        _rankLabel(rank),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      );

      // Each rank gets width proportional to number of strength levels
      final flex = (rank == PlayerRank.open) ? 1 : PlayerStrength.values.length;

      labels.add(
        Expanded(
          flex: flex,
          child: Center(child: label),
        ),
      );
    }

    return labels;
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    final startIndex = _currentRange.start.round();
    final endIndex = _currentRange.end.round();
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
              data:
                  SliderTheme.of(
                    context,
                  ).copyWith(
                    activeTrackColor: Colors.lightGreen,
                    thumbColor: Colors.green,
                  ),
              child: RangeSlider(
                divisions: _rankLabels.length - 1,
                values: _currentRange,
                min: 0,
                max: _rankLabels.length - 1,
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRange = RangeValues(
                      values.start.roundToDouble(),
                      values.end.roundToDouble(),
                    );
                  });
                },
                onChangeEnd: (values) {
                  final startIndex = values.start.round();
                  final endIndex = values.end.round();

                  final (startRank, startStrength) = _levelPair[startIndex];
                  final (endRank, endStrength) = _levelPair[endIndex];

                  playerLevel = PlayerLevel(
                    rank: RankRange(startRank, endRank),
                    strength: StrengthRange(
                      startStrength ?? PlayerStrength.strong,
                      endStrength ?? PlayerStrength.strong,
                    ),
                  );
                  widget.onSliderChanged(playerLevel);
                },
                labels: RangeLabels(
                  _rankLabels[startIndex],
                  _rankLabels[endIndex],
                ),
              ),
            ),
            // Strength labels
            Row(
              children: List.generate(
                _strengthLabels.length,
                (i) => Expanded(
                  child: Center(
                    child: Text(
                      _strengthLabels[i],
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(children: _buildRankLabels()),
          ],
        ),
      ),
    );
  }
}
