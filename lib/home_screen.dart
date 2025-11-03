import 'package:flutter/material.dart';
import 'game_list.dart';
import 'player_list.dart';
import 'user_settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const GameList(),
    const PlayerList(),
    const UserSettings(),
  ];

  late final List<AppBarConfig> _appBars = [
    //for the game list section
    AppBarConfig(
      title: const Text("Games"),
      actionsBuilder: (context) => [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Add Game',
          onPressed: () => (_pages[0] as GameList).onAddGame?.call(context),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          color: Colors.blueGrey.shade50,
          padding: const EdgeInsets.all(8),
          child: const Text("Game Filters", style: TextStyle(fontSize: 14)),
        ),
      ),
    ),

    //for the player list section
    AppBarConfig(
      title: const Text("Players"),
      actionsBuilder: (context) => [
        IconButton(
          icon: const Icon(Icons.person_add),
          tooltip: 'Add Player',
          onPressed: () => (_pages[1] as PlayerList).onAddPlayer?.call(context),
        ),
      ],
    ),

    //for the settings section
    AppBarConfig(
      title: const Text("Settings"),
      actionsBuilder: (context) => [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appBarConfig = _appBars[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: appBarConfig.title,
        actions: appBarConfig.actionsBuilder(context),
        bottom: appBarConfig.bottom,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_tennis),
            label: "Games",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Players"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class AppBarConfig {
  final Widget title;
  final List<Widget> Function(BuildContext) actionsBuilder;
  final PreferredSizeWidget? bottom;

  const AppBarConfig({
    required this.title,
    required this.actionsBuilder,
    this.bottom,
  });
}
