import 'package:badminton_app/game_edit.dart';
import 'package:badminton_app/model/games.dart';
import 'package:badminton_app/model/players.dart';
import 'package:badminton_app/widgets/game_player_add.dart';
import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  final Games games;
  final List<Players> players;
  const GameView({
    super.key,
    required this.games,
    required this.players,
  });

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  Future<void> _openEditGame() async {
    final result = await Navigator.push<Games>(
      context,
      MaterialPageRoute(
        builder: (context) => GameEdit(
          game: widget.games,
          onEditGame: (_) {},
        ),
      ),
    );

    if (!mounted) return;

    if (result == 'delete') {
      Navigator.pop(context, 'delete');
    } else if (result is Games) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.games.title;
    final courtName = widget.games.court.courtName;
    final rate = widget.games.court.courtRate;
    final shuttlecockPrice = widget.games.court.shuttlecockPrice;
    final isDivided = widget.games.court.isDivided;
    final sections = widget.games.court.section;

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

    //price computation variables
    final totalPrice = widget.games.totalPrice;
    final perPlayerShare = widget.games.perPlayerShare;
    final playerCount = widget.games.playerCount;

    //gam player add handler
    void assignPlayerToSection(Players p, int sectionIndex) {
      setState(() {
        final old = widget.games.court.section[sectionIndex];
        final schedule = old?.schedule ?? CourtSchedule(start: null, end: null);
        final existingPlayers = (old?.players != null)
            ? List<Players>.from(old!.players!)
            : <Players>[];
        existingPlayers.add(p);
        final updatedSection = CourtSection(
          players: existingPlayers,
          schedule: schedule,
        );
        widget.games.court.section[sectionIndex] = updatedSection;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${p.fullName} assigned to Court ${sectionIndex + 1}'),
        ),
      );
    }

    //THE UI BUILDING SECTION
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
        actions: [
          IconButton(
            onPressed: _openEditGame,
            icon: const Icon(Icons.edit),
          ),
        ],
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
                        const CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          radius: 18,
                          child: Icon(Icons.location_on, size: 18),
                        ),
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
                        const CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          radius: 18,
                          child: Icon(Icons.monetization_on, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Court Rate: ₱ ${rate.toStringAsFixed(2)}/hour',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          radius: 18,
                          child: Icon(Icons.sports_tennis, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Shuttlecock Price: ₱ ${shuttlecockPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          radius: 18,
                          child: Icon(Icons.balance, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Divide Equally: $isDivided',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    //pricing summary
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 1,
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Price: ₱${totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isDivided
                                    ? 'Per Player Share ($playerCount players): ₱${perPlayerShare.toStringAsFixed(2)}'
                                    : 'Individual Payment',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current players in game: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                GamePlayerAdd(
                  players: widget.players,
                  sections: widget.games.court.section,
                  onPlayerAssigned: assignPlayerToSection,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: widget.games.currentPlayers.map((p) {
                return Card(
                  child: ListTile(
                    title: Text(p.fullName),
                    subtitle: const Text('Assigned to a section'),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
