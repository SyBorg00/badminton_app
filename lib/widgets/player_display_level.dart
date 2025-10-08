import 'package:badminton_app/model/players.dart';
import 'package:flutter/material.dart';

class PlayerDisplayLevel extends StatelessWidget {
  final PlayerRank startRank;
  final PlayerRank endRank;
  final PlayerStrength startStrength;
  final PlayerStrength endStrength;

  const PlayerDisplayLevel({
    super.key,
    required this.startRank,
    required this.endRank,
    required this.startStrength,
    required this.endStrength,
  });

  @override
  Widget build(BuildContext context) {
    Color? rankColor(PlayerRank rank) {
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

    String levelLabel(PlayerRank rank, PlayerStrength strength) {
      String rankStr = '';
      String strengthStr = '';
      switch (rank) {
        case PlayerRank.intermediate:
          rankStr = 'Intermediate';
          break;
        case PlayerRank.levelG:
          rankStr = 'G';
          break;
        case PlayerRank.levelF:
          rankStr = 'F';
          break;
        case PlayerRank.levelE:
          rankStr = 'E';
          break;
        case PlayerRank.levelD:
          rankStr = 'D';
          break;
        case PlayerRank.open:
          rankStr = 'Open';
          break;
      }
      switch (strength) {
        case PlayerStrength.weak:
          strengthStr = 'Weak';
          break;
        case PlayerStrength.mid:
          strengthStr = 'Mid';
          break;
        case PlayerStrength.strong:
          strengthStr = 'Strong';
          break;
      }
      return (rankStr != 'Open') ? '$strengthStr $rankStr' : rankStr;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                rankColor(startRank) ?? Colors.grey,
                rankColor(endRank) ?? Colors.grey,
              ],
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              levelLabel(startRank, startStrength),
              style: const TextStyle(
                color: Color.fromARGB(255, 112, 112, 112),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              levelLabel(endRank, endStrength),
              style: const TextStyle(
                color: Color.fromARGB(255, 112, 112, 112),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
