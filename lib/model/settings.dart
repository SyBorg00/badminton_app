class UserSettings {
  final String defaultCourtName;
  final double defaultCourtRate;
  final double defaultShuttlecockPrice;
  final bool divideEqually;

  UserSettings({
    required this.defaultCourtName,
    required this.defaultCourtRate,
    required this.defaultShuttlecockPrice,
    required this.divideEqually,
  });

  Map<String, dynamic> toMap() => {
    'defaultCourtName': defaultCourtName,
    'defaultCourtRate': defaultCourtRate,
    'defaultShuttlecockPrice': defaultShuttlecockPrice,
    'divideEqually': divideEqually,
  };

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      defaultCourtName: map['defaultCourtName'] ?? '',
      defaultCourtRate: (map['defaultCourtRate'] ?? 0).toDouble(),
      defaultShuttlecockPrice: (map['defaultShuttlecockPrice'] ?? 0).toDouble(),
      divideEqually: map['divideEqually'] ?? true,
    );
  }
}
