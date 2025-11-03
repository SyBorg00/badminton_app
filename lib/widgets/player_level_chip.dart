import 'package:badminton_app/model/players.dart';
import 'package:flutter/material.dart';

class PlayerLevelChip extends StatelessWidget {
  final PlayerRank rankLabel;
  final PlayerStrength strengthLabel;

  const PlayerLevelChip({
    super.key,
    required this.rankLabel,
    required this.strengthLabel,
  });

  @override
  Widget build(BuildContext context) {
    String _rankLabel(PlayerRank rank) {
      switch (rank) {
        case PlayerRank.intermediate:
          return "Interm";
        case PlayerRank.levelG:
          return "G";
        case PlayerRank.levelF:
          return "F";
        case PlayerRank.levelE:
          return "E";
        case PlayerRank.levelD:
          return "D";
        case PlayerRank.open:
          return "Open";
      }
    }

    MaterialColor? _rankColor(PlayerRank rank) {
      switch (rank) {
        case PlayerRank.intermediate:
          return Colors.red;
        case PlayerRank.levelG:
          return Colors.orange;
        case PlayerRank.levelF:
          return Colors.yellow;
        case PlayerRank.levelE:
          return Colors.lime;
        case PlayerRank.levelD:
          return Colors.lightGreen;
        case PlayerRank.open:
          return Colors.green;
      }
    }

    return Chip(
      avatar: SizedBox(
        width: 40,
        height: 40,
        child: CircleAvatar(radius: 20, child: Text(_rankLabel(rankLabel))),
      ),
      label: Text(
        strengthLabel.displayName,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
