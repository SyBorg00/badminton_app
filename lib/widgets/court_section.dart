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
  final List<CourtSchedule> schedule = [];

  @override
  void initState() {
    super.initState();
    // Initialize local schedule list from the provided sections so existing
    // schedule values (start/end) are preserved when editing.
    final sections = widget.section ?? [];
    for (final sec in sections) {
      if (sec?.schedule != null) {
        schedule.add(sec!.schedule);
      } else {
        schedule.add(CourtSchedule(start: null, end: null));
      }
    }
  }

  @override
  void didUpdateWidget(covariant CourtSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent sections changed (e.g., when opening editor with existing
    // data), refresh the local schedule list to reflect those values.
    final oldLen = oldWidget.section?.length ?? 0;
    final newLen = widget.section?.length ?? 0;
    if (oldLen != newLen) {
      schedule.clear();
      final sections = widget.section ?? [];
      for (final sec in sections) {
        if (sec?.schedule != null) {
          schedule.add(sec!.schedule);
        } else {
          schedule.add(CourtSchedule(start: null, end: null));
        }
      }
      setState(() {});
    } else {
      // If lengths equal, try to sync individual schedules
      final sections = widget.section ?? [];
      for (var i = 0; i < sections.length; i++) {
        final incoming = sections[i]?.schedule;
        if (incoming != null) {
          // replace only when local is null to avoid overwriting user changes
          if (schedule.length <= i ||
              schedule[i].start == null && schedule[i].end == null) {
            if (schedule.length <= i)
              schedule.add(incoming);
            else
              schedule[i] = incoming;
          }
        }
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectScheduleRange(int index) async {
    final sched = schedule[index];

    // pick a date first
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: sched.start ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !mounted) return;

    // initial time for start
    final TimeOfDay initialStartTime = sched.start != null
        ? TimeOfDay.fromDateTime(sched.start!)
        : TimeOfDay.now();

    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: initialStartTime,
    );
    if (startTime == null || !mounted) return;

    // initial time for end (use existing end or start + 1 hour)
    final TimeOfDay initialEndTime = sched.end != null
        ? TimeOfDay.fromDateTime(sched.end!)
        : TimeOfDay(
            hour: (startTime.hour + 1) % 24,
            minute: startTime.minute,
          );

    final TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: initialEndTime,
    );
    if (endTime == null || !mounted) return;

    final startDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      startTime.hour,
      startTime.minute,
    );

    final endDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      endTime.hour,
      endTime.minute,
    );

    if (!endDateTime.isAfter(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    setState(() {
      schedule[index] = CourtSchedule(start: startDateTime, end: endDateTime);
    });

    _updateParent();
  }

  void _updateParent() {
    final updatedSections = List<CourtSection?>.generate(
      schedule.length,
      (i) {
        // Preserve any existing players list from the original sections
        final players = widget.section != null && widget.section!.length > i
            ? widget.section![i]?.players
            : null;
        return CourtSection(
          players: players,
          schedule: schedule[i],
        );
      },
    );

    widget.onSectionChanged?.call(updatedSections);
  }

  void _addSection() {
    setState(() {
      schedule.add(CourtSchedule(start: null, end: null));
    });
    _updateParent();
  }

  void _removeSection(int index) {
    setState(() {
      schedule.removeAt(index);
    });
    _updateParent();
  }

  String _formatDateTimeRange(CourtSchedule sched) {
    if (sched.start == null || sched.end == null) return 'Select Time Range';
    final start = sched.start!;
    final end = sched.end!;
    final startTime = TimeOfDay.fromDateTime(start).format(context);
    final endTime = TimeOfDay.fromDateTime(end).format(context);
    final date =
        '${start.month.toString().padLeft(2, '0')}/${start.day.toString().padLeft(2, '0')}/${start.year}';
    return '$date $startTime - $endTime';
  }

  @override
  Widget build(BuildContext context) {
    final hasSections = schedule.isNotEmpty;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasSections)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 64, child: Text('Court #')),
                  SizedBox(width: 8),
                  Expanded(child: Text('Schedule')),
                  SizedBox(width: 48),
                ],
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final sched = schedule[index];
              final scheduleText = _formatDateTimeRange(sched);
              final courtNumber = index + 1;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 64,
                      child: Text(
                        courtNumber.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(
                            255,
                            55,
                            122,
                            48,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(5),
                          ),
                        ),
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
