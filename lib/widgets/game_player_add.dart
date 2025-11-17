// ...existing code...
import 'package:flutter/material.dart';
import 'package:badminton_app/model/players.dart';
import 'package:badminton_app/model/games.dart';

class GamePlayerAdd extends StatefulWidget {
  final List<Players> players;
  final List<CourtSection?> sections;
  final void Function(Players player, int sectionIndex) onPlayerAssigned;

  const GamePlayerAdd({
    super.key,
    required this.players,
    required this.sections,
    required this.onPlayerAssigned,
  });

  @override
  State<GamePlayerAdd> createState() => _GamePlayerAddState();
}

class _GamePlayerAddState extends State<GamePlayerAdd> {
  String? _selectedName;
  int? _selectedSectionIndex;

  Future<void> _openPicker() async {
    final players = widget.players;
    final sections = widget.sections;

    if (players.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No players available'),
          content: const Text(
            'There are no players in the app yet. Add players from the Players tab before adding to a game.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (sections.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No sections available'),
          content: const Text('Create a court section for this game first.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    _selectedName = players.first.fullName;
    _selectedSectionIndex = 0;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setStateDialog) => AlertDialog(
          title: const Text('Assign Player to Section'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedName,
                items: players
                    .map<DropdownMenuItem<String>>(
                      (p) => DropdownMenuItem<String>(
                        value: p.fullName,
                        child: Text(p.fullName),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setStateDialog(() => _selectedName = v),
                decoration: InputDecoration(
                  labelText: 'Select player',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: const TextStyle(color: Colors.black),
                  floatingLabelStyle: const TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _selectedSectionIndex,
                items: List.generate(sections.length, (i) {
                  final s = sections[i];
                  final dateLabel = s?.schedule.start != null
                      ? ' — ${s!.schedule.start!.month.toString().padLeft(2, '0')}/${s.schedule.start!.day.toString().padLeft(2, '0')}/${s.schedule.start!.year}'
                      : '';
                  final playersCount = s?.players?.length ?? 0;
                  final fullBadge = playersCount >= 4 ? ' (full)' : '';
                  final label =
                      'Court ${i + 1}$dateLabel — $playersCount/4$fullBadge';
                  return DropdownMenuItem<int>(value: i, child: Text(label));
                }),
                onChanged: (v) =>
                    setStateDialog(() => _selectedSectionIndex = v),
                decoration: InputDecoration(
                  labelText: 'Select section',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: const TextStyle(color: Colors.black),
                  floatingLabelStyle: const TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if ((_selectedName ?? '').trim().isEmpty ||
                    _selectedSectionIndex == null) {
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );

    if (result == true &&
        _selectedName != null &&
        _selectedSectionIndex != null) {
      final picked = players.firstWhere(
        (p) => p.fullName == _selectedName,
        orElse: () => players.first,
      );
      widget.onPlayerAssigned(picked, _selectedSectionIndex!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person_add, color: Colors.green),
      onPressed: _openPicker,
      tooltip: 'Add player',
    );
  }
}
