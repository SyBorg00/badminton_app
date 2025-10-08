import 'package:badminton_app/widgets/player_display_level.dart';
import 'package:flutter/material.dart';
import 'package:badminton_app/model/players.dart';

class PlayerCard extends StatelessWidget {
  final Players player;
  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    //for the profiles

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 30,
                child: Text(
                  player.nickName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      player.nickName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      player.fullName,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 70, 70, 70),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PlayerDisplayLevel(
                      startRank: player.level.rank.start,
                      endRank: player.level.rank.end,
                      startStrength: player.level.strength.start,
                      endStrength: player.level.strength.end,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
