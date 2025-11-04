import 'package:flutter/material.dart';
import 'game_list.dart';
import 'player_list.dart';
import 'user_settings.dart';
import 'model/games.dart';
import 'model/players.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Games> _games = [];
  final List<Players> _players = [];

  void _handleAddGame(Games game) {
    setState(() {
      _games.add(game);
    });
  }

  void _handleDeleteGame(Games game) {
    setState(() {
      _games.removeWhere((g) => g.id == game.id);
    });
  }

  void _handleAddPlayer(Players player) {
    setState(() {
      _players.add(player);
    });
  }

  void _handleEditPlayer(Players player) {
    setState(() {
      final index = _players.indexWhere((p) => p.id == player.id);
      if (index != -1) {
        _players[index] = player;
      }
    });
  }

  void _handleDeletePlayer(Players player) {
    setState(() {
      _players.removeWhere((p) => p.id == player.id);
    });
  }

  late final List<Widget> _pages = [
    GameList(
      gameList: _games,
      onAddGame: _handleAddGame,
      onDeleteGame: _handleDeleteGame,
    ),
    PlayerList(
      playerList: _players,
      onAddPlayer: _handleAddPlayer,
      onEditPlayer: _handleEditPlayer,
      onDeletePlayer: _handleDeletePlayer,
    ),
    const UserSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
