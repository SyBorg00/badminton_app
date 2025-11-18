import 'package:badminton_app/model/players.dart';

class Games {
  final String id;
  final String title;
  final GameCourt court;

  Games({
    required this.id,
    required this.title,
    required this.court,
  });

  //Function: get the total player count in each games
  int get playerCount {
    final seen = <String>{};
    for (final section in court.section) {
      if (section?.players != null) {
        for (final p in section!.players!) {
          final key = '${p.id}|${p.fullName}|${p.nickName}';
          seen.add(key);
        }
      }
    }
    return seen.length;
  }

  //Function: get current players (almost similar huh)
  List<Players> get currentPlayers {
    final Map<String, Players> unique = {};
    for (final section in court.section) {
      if (section?.players != null) {
        for (final p in section!.players!) {
          final key = '${p.id}|${p.fullName}|${p.nickName}';
          unique[key] = p;
        }
      }
    }
    return unique.values.toList();
  }

  //Function: get the total COST of the game (not PRICE but let's stick to that to prevent further issues)
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
    return total;
  }

  //Function: get the total COST if the divide court equally is CHECKED
  double get perPlayerCourtShare {
    if (court.isDivided && playerCount > 0) {
      return totalPrice / playerCount;
    }
    return totalPrice;
  }

  double get perPlayerShuttleCockShare {
    if (court.isDivided && playerCount > 0) {
      return court.shuttlecockPrice / playerCount;
    }
    return court.shuttlecockPrice;
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

//Should be court block but dunno about badminton terms
class CourtSection {
  final List<Players>? players; //the players who join this court section
  final CourtSchedule schedule;

  CourtSection({
    this.players,
    required this.schedule,
  });
}

class CourtSchedule {
  final DateTime? start;
  final DateTime? end;
  CourtSchedule({required this.start, required this.end});
}
