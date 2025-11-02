import 'package:badminton_app/model/games.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final Games games;
  const GameCard({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(games.title),
          Text(
            '${games.court.section.schedule.start} - ${games.court.section.schedule.end}',
          ),
          Text(games.playerCount.toString()),
          Text(games.total.toString()),
        ],
      ),
    );
  }
}
