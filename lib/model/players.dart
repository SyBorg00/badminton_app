enum PlayerRank { intermediate, levelG, levelF, levelE, levelD, open }

enum PlayerStrength { weak, mid, strong }

class Players {
  final String id;
  final String nickName;
  final String fullName;
  final String mobileNumber;
  final String email;
  final String address;
  final String remarks;
  final PlayerLevel level;

  Players({
    required this.id,
    required this.nickName,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.remarks,
    required this.level,
  });
}

class RankRange {
  final PlayerRank start;
  final PlayerRank end;
  RankRange(this.start, this.end);
}

class StrengthRange {
  final PlayerStrength start;
  final PlayerStrength end;
  StrengthRange(this.start, this.end);
}

class PlayerLevel {
  final RankRange rank;
  final StrengthRange strength;

  PlayerLevel({
    required this.rank,
    required this.strength,
  });
}

extension EnumDisplayName on Enum {
  String get displayName {
    final name = this.name;
    final withSpaces = name.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
    return withSpaces[0].toUpperCase() + withSpaces.substring(1);
  }
}
