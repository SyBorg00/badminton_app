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
  final List<Players> _players = [
    Players(
      id: '1',
      nickName: 'Billy',
      fullName: 'Billy Bob',
      mobileNumber: '1234567890',
      email: 'billy@example.com',
      address: '123 Main St',
      remarks: 'Good player',
      level: PlayerLevel(
        rank: RankRange(PlayerRank.intermediate, PlayerRank.levelD),
        strength: StrengthRange(PlayerStrength.mid, PlayerStrength.strong),
      ),
    ),
    Players(
      id: '2',
      nickName: 'Ellie',
      fullName: 'Ellie Smith',
      mobileNumber: '0987654321',
      email: 'ellie@example.com',
      address: '456 Elm St',
      remarks: 'Excellent player',
      level: PlayerLevel(
        rank: RankRange(PlayerRank.levelE, PlayerRank.levelD),
        strength: StrengthRange(PlayerStrength.strong, PlayerStrength.strong),
      ),
    ),
    Players(
      id: '3',
      nickName: 'Charles',
      fullName: 'Charles Brown',
      mobileNumber: '1234567890',
      email: 'charles@example.com',
      address: '123 Main St',
      remarks: 'Good player',
      level: PlayerLevel(
        rank: RankRange(PlayerRank.levelF, PlayerRank.levelE),
        strength: StrengthRange(PlayerStrength.mid, PlayerStrength.strong),
      ),
    ),
    Players(
      id: '4',
      nickName: 'Henry',
      fullName: 'Henry Ford',
      mobileNumber: '1234567890',
      email: 'henry@example.com',
      address: '123 Main St',
      remarks: 'Eh player',
      level: PlayerLevel(
        rank: RankRange(PlayerRank.intermediate, PlayerRank.levelF),
        strength: StrengthRange(PlayerStrength.mid, PlayerStrength.strong),
      ),
    ),
  ];

  void _handleAddGame(Games game) {
    setState(() {
      _games.add(game);
    });
  }

  void _handleEditGame(Games game) {
    setState(() {
      final index = _games.indexWhere((g) => g.id == game.id);
      if (index != -1) {
        _games[index] = game;
      }
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
      players: _players,
      onAddGame: _handleAddGame,
      onEditGame: _handleEditGame,
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
        selectedItemColor: Colors.green,
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
