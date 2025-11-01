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
  late final List<TextEditingController> numberController;
  late final List<CourtSchedule> schedule;

  @override
  void initState() {
    super.initState();
    final length = widget.section?.length ?? 5;
    numberController.addAll(List.generate(5, (_) => TextEditingController()));
    schedule.addAll(
      List.generate(length, (_) => CourtSchedule(start: null, end: null)),
    );
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
      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Row(
            children: [
              Text('Court Number'),
              Text('Schedule (Start - End)'),
            ],
          ),
          ListView.builder(
            itemCount: widget.section?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final sched = schedule[index];
              final scheduleText = (sched.start != null && sched.end != null)
                  ? '${sched.start!.format(context)} - ${sched.end!.format(context)}'
                  : 'Select Time Range';

              return Row(
                children: [
                  TextFormField(
                    controller: numberController[index],
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _updateParent(),
                  ),

                  ElevatedButton(
                    onPressed: () => _selectScheduleRange(index),
                    child: Text(scheduleText),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
