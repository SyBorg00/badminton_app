import 'package:badminton_app/model/players.dart';
import 'package:flutter/material.dart';

class Games {
  final String id;
  final String title;
  final GameCourt court;

  Games({
    required this.id,
    required this.title,
    required this.court,
  });

  int get playerCount {
    final allPlayers = <Players>{};

    for (final section in court.section) {
      if (section?.player != null) {
        allPlayers.addAll(section!.player!);
      }
    }

    return allPlayers.length;
  }

  double get totalPrice {
    double total = 0;
    for (final section in court.section) {
      if (section == null) continue;
      final start = section.schedule.start;
      final end = section.schedule.end;

      if (start != null && end != null) {
        final durationInMinutes = end.difference(start).inMinutes;
        final duration = durationInMinutes / 60.0;
        total += court.courtRate * duration;
      }
    }

    total += court.shuttlecockPrice;
    return total;
  }

  double get perPlayerShare {
    if (court.isDivided && playerCount > 0) {
      return totalPrice / playerCount;
    }
    return totalPrice;
  }
}

class GameCourt {
  final String courtName;
  final double courtRate;
  final double shuttlecockPrice;
  final List<CourtSection?> section;
  final bool isDivided;

  GameCourt({
    required this.courtName,
    required this.courtRate,
    required this.shuttlecockPrice,
    required this.section,
    required this.isDivided,
  });
}

class CourtSection {
  final List<Players>? player; //the players who join this court section
  final CourtSchedule schedule;

  CourtSection({
    this.player,
    required this.schedule,
  });
}

class CourtSchedule {
  final DateTime? start;
  final DateTime? end;
  CourtSchedule({required this.start, required this.end});
}
