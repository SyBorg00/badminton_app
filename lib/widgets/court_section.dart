import 'package:badminton_app/model/games.dart';
import 'package:flutter/material.dart';

class CourtSectionWidget extends StatefulWidget {
  final List<CourtSection?>? section;
  final ValueChanged<List<CourtSection?>>? onSectionChanged;

  const CourtSectionWidget({
    super.key,
    this.section,
    this.onSectionChanged,
  });

  @override
  State<CourtSectionWidget> createState() => _CourtSectionWidgetState();
}

class _CourtSectionWidgetState extends State<CourtSectionWidget> {
  final List<TextEditingController> numberController = [];
  final List<CourtSchedule> schedule = [];

  @override
  void initState() {
    super.initState();
    final length = widget.section?.length ?? 0;

    numberController.addAll(
      List.generate(length, (_) => TextEditingController()),
    );

    schedule.addAll(
      List.generate(length, (_) => CourtSchedule(start: null, end: null)),
    );
  }

  @override
  void dispose() {
    for (final controller in numberController) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectScheduleRange(int index) async {
    final sched = schedule[index];

    final TimeOfDay? start = await showTimePicker(
      context: context,
      initialTime: sched.start ?? TimeOfDay.now(),
    );
    if (start == null || !mounted) return;

    final TimeOfDay? end = await showTimePicker(
      context: context,
      initialTime:
          sched.end ??
          TimeOfDay(hour: (start.hour + 1) % 24, minute: start.minute),
    );
    if (end == null || !mounted) return;

    final startMin = start.hour * 60 + start.minute;
    final endMin = end.hour * 60 + end.minute;
    if (endMin <= startMin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    setState(() {
      schedule[index] = CourtSchedule(start: start, end: end);
    });

    _updateParent();
  }

  void _updateParent() {
    final updatedSections = List<CourtSection?>.generate(
      numberController.length,
      (i) {
        final numText = numberController[i].text;
        final numValue = int.tryParse(numText) ?? (i + 1);
        return CourtSection(
          number: numValue,
          schedule: schedule[i],
        );
      },
    );

    widget.onSectionChanged?.call(updatedSections);
  }

  void _addSection() {
    setState(() {
      numberController.add(TextEditingController());
      schedule.add(CourtSchedule(start: null, end: null));
    });
    _updateParent();
  }

  void _removeSection(int index) {
    setState(() {
      numberController[index].dispose();
      numberController.removeAt(index);
      schedule.removeAt(index);
    });
    _updateParent();
  }

  @override
  Widget build(BuildContext context) {
    final hasSections = numberController.isNotEmpty;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasSections)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(child: Text('Court Number')),
                  SizedBox(width: 8),
                  Expanded(child: Text('Schedule (Start - End)')),
                  SizedBox(width: 48), // space for remove button
                ],
              ),
            ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: numberController.length,
            itemBuilder: (context, index) {
              final sched = schedule[index];
              final scheduleText = (sched.start != null && sched.end != null)
                  ? '${sched.start!.format(context)} - ${sched.end!.format(context)}'
                  : 'Select Time Range';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: numberController[index],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Court #'),
                        onChanged: (_) => _updateParent(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectScheduleRange(index),
                        child: Text(scheduleText),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeSection(index),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: _addSection,
              icon: const Icon(Icons.add),
              label: const Text('Add Section'),
            ),
          ),
        ],
      ),
    );
  }
}
