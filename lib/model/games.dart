import 'package:flutter/material.dart';

class Games {
  final String id;
  final String title;
  final int playerCount;
  final int total;

  final GameCourt court;

  Games({
    required this.id,
    required this.title,
    required this.playerCount,
    required this.total,
    required this.court,
  });
}

class GameCourt {
  final String courtName;
  final double courtRate;
  final double shottlecockPrice;
  final List<CourtSection?> section;
  final bool isDivided;

  GameCourt({
    required this.courtName,
    required this.courtRate,
    required this.shottlecockPrice,
    required this.section,
    required this.isDivided,
  });
}

class CourtSection {
  final int number;
  final CourtSchedule schedule;

  CourtSection({
    required this.number,
    required this.schedule,
  });
}

class CourtSchedule {
  final TimeOfDay? start;
  final TimeOfDay? end;
  CourtSchedule({required this.start, required this.end});
}
