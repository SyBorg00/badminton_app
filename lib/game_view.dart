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

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
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
                        const Icon(Icons.person_2, size: 18),
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
                        const Icon(Icons.person_2, size: 18),
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
              'Court Sections',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: sections.isEmpty
                  ? const Text('No court sections available')
                  : ListView.builder(
                      itemCount: sections.length,
                      itemBuilder: (context, index) {
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
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
