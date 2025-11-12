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
      headerText = title;
    }

    //price computation variables
    final totalPrice = widget.games.totalPrice;
    final perPlayerShare = widget.games.perPlayerShare;

    //game player add handler
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

    // remove player from a section
    void removePlayerFromSection(Players p, int sectionIndex) {
      setState(() {
        final old = widget.games.court.section[sectionIndex];
        final schedule = old?.schedule ?? CourtSchedule(start: null, end: null);
        final existingPlayers = (old?.players != null)
            ? List<Players>.from(old!.players!)
            : <Players>[];
        existingPlayers.removeWhere((pl) => pl.id == p.id);
        final updatedSection = CourtSection(
          players: existingPlayers.isEmpty ? null : existingPlayers,
          schedule: schedule,
        );
        widget.games.court.section[sectionIndex] = updatedSection;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${p.fullName} removed from Court ${sectionIndex + 1}'),
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
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: _openEditGame,
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerText,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            //game details section
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
                        const SizedBox(width: 14),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Court Name:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                courtName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          radius: 18,
                          child: Icon(Icons.monetization_on, size: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Court Rate:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                ' ₱ ${rate.toStringAsFixed(2)}/hour',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
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
                          child: Icon(Icons.sports_tennis, size: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Shuttlecock Price:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                ' ₱ ${shuttlecockPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Divide Court Equally:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                isDivided ? "Yes" : "No",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "TOTAL PRICE: ",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '₱ ${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isDivided
                                    ? 'Shared Payment per Player'
                                    : 'Individual Payment',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 77, 136, 81),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isDivided
                                    ? 'Each player pays a shared amount of ₱${perPlayerShare.toStringAsFixed(2)} for court and shuttlecock fees'
                                    : 'Each player pays their own court and shuttlecock fees',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
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

            //court schedule section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Court Schedules',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 4),
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.games,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      'Court ${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    subtitle: Text(scheduleText),
                                    trailing: Text(
                                      "Total Duration: $durationText",
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Player chips for this section
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Builder(
                                      builder: (_) {
                                        final playersInSection =
                                            s?.players ?? <Players>[];
                                        if (playersInSection.isEmpty) {
                                          return const Text(
                                            'No players assigned',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          );
                                        }
                                        return Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: playersInSection.map((p) {
                                            final label =
                                                (p.nickName.trim().isNotEmpty)
                                                ? p.nickName
                                                : p.fullName;
                                            return Chip(
                                              label: Text(label),
                                              backgroundColor:
                                                  Colors.green.shade50,
                                              avatar: CircleAvatar(
                                                backgroundColor: Colors.green,
                                                child: Text(
                                                  label.isNotEmpty
                                                      ? label[0].toUpperCase()
                                                      : '?',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              onDeleted: () =>
                                                  removePlayerFromSection(
                                                    p,
                                                    index,
                                                  ),
                                              deleteIcon: const Icon(
                                                Icons.close,
                                                size: 16,
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            //current player section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Players',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GamePlayerAdd(
                          players: widget.players,
                          sections: widget.games.court.section,
                          onPlayerAssigned: assignPlayerToSection,
                        ),
                      ],
                    ),
                    const Divider(height: 12),
                    const SizedBox(height: 8),
                    if (widget.games.currentPlayers.isEmpty)
                      const Text('No players assigned to this game yet.')
                    else
                      Column(
                        children: widget.games.currentPlayers.map((p) {
                          final label = p.nickName.trim().isNotEmpty
                              ? p.nickName
                              : p.fullName;
                          // find which sections this player is assigned to
                          final assigned = <int>[];
                          for (
                            var i = 0;
                            i < widget.games.court.section.length;
                            i++
                          ) {
                            final s = widget.games.court.section[i];
                            if (s?.players != null &&
                                s!.players!.any((pl) => pl.id == p.id)) {
                              assigned.add(i + 1);
                            }
                          }
                          final subtitleText = assigned.isEmpty
                              ? 'Not assigned'
                              : (assigned.length == 1
                                    ? 'Assigned to Court ${assigned.first}'
                                    : 'Assigned to Courts ${assigned.join(', ')}');

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Text(
                                  label.isNotEmpty
                                      ? label[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              subtitle: Text(subtitleText),
                            ),
                          );
                        }).toList(),
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
