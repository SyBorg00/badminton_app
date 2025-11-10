import 'package:badminton_app/model/games.dart';
import 'package:flutter/material.dart';

class GameView extends StatelessWidget {
  final Games games;
  const GameView({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    final title = games.title;
    final courtName = games.court.courtName;
    final rate = games.court.courtRate;
    final shuttlecockPrice = games.court.shuttlecockPrice;
    final isDivided = games.court.isDivided;
    final sections = games.court.section;

    String headerText;
    if (title.trim().isEmpty) {
      String dateText = 'No schedule';
      if (sections.isNotEmpty) {
        final firstSched = sections.first?.schedule;
        final start = firstSched?.start;
        if (start != null) {
          dateText =
              '${start.month.toString().padLeft(2, '0')}/${start.day.toString().padLeft(2, '0')}/${start.year}';
        }
      }
      headerText = dateText;
    } else {
      headerText = 'Game Title: $title';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Game Title: $headerText",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Game Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Court Name: $courtName',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Court Rate: ₱ $rate/hour',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.sports_tennis, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Shuttlecock Price: ₱ $shuttlecockPrice',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.balance, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Divide Equally: $isDivided',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Court Schedules',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            const SizedBox(height: 8),
            if (sections.isEmpty)
              const Text('No court sections available')
            else
              Column(
                children: List.generate(sections.length, (index) {
                  final s = sections[index];
                  final sched = s?.schedule;
                  final scheduleText =
                      (sched?.start != null && sched?.end != null)
                      ? '${TimeOfDay.fromDateTime(sched!.start!).format(context)} - ${TimeOfDay.fromDateTime(sched.end!).format(context)}'
                      : 'Select Time Range';

                  final durationText =
                      (sched?.start != null && sched?.end != null)
                      ? ' (${sched!.end!.difference(sched.start!).inHours} hrs)'
                      : '';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.games,
                          color: Colors.white,
                        ),
                      ),
                      title: Text('Court $index'),
                      subtitle: Text(scheduleText),
                      trailing: Text("Total Duration: $durationText"),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 40),
            const Text(
              'Current Players',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            const SizedBox(
              height: 30,
            ),
            if (games.playerCount == 0)
              const Center(child: Text('No current players assigned'))
            else
              Column(
                children: List.generate(games.playerCount, (index) {
                  final players = games.currentPlayers;
                  return Card(
                    child: ListTile(
                      title: Text(players[index].fullName),
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
