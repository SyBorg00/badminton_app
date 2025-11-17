import 'package:badminton_app/model/games.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final Games games;
  const GameCard({super.key, required this.games});

  String _formatDateTime(DateTime? dt, BuildContext context) {
    if (dt == null) return "--:--";
    final tod = TimeOfDay.fromDateTime(dt);
    return tod.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final firstSection = games.court.section.isNotEmpty
        ? games.court.section.first
        : null;

    final scheduleText = firstSection != null
        ? "${_formatDateTime(firstSection.schedule.start, context)} - ${_formatDateTime(firstSection.schedule.end, context)}"
        : "---";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              padding: EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 45,
                child: Icon(
                  Icons.sports_tennis,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      games.title.isNotEmpty ? games.title : scheduleText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      scheduleText,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Players: ${games.playerCount}",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 70, 70, 70),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total Cost: ₱${games.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
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
