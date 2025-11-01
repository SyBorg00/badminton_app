import 'package:badminton_app/game_add.dart';
import 'package:badminton_app/model/games.dart';
import 'package:badminton_app/widgets/game_card.dart';
import 'package:flutter/material.dart';

class GameList extends StatefulWidget {
  const GameList({super.key});

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  final List<Games> gameList = [
    Games(
      title: "Testing",
      playerCount: 2,
      total: 200,
      court: GameCourt(
        courtName: 'Hmm',
        courtRate: 45,
        shottlecockPrice: 500,
        section: CourtSection(
          number: 1,
          schedule: CourtSchedule(start: TimeOfDay.now(), end: TimeOfDay.now()),
        ),
        isDivided: false,
      ),
    ),
  ];

  void _addGame(Games games) {
    setState(() {
      gameList.add(games);
    });
  }

  void _showAddGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => GameAdd(
          onAddGame: _addGame,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: gameList.isEmpty
            ? const Text("No games listed yet")
            : ListView.builder(
                itemCount: gameList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: ValueKey(gameList[index]),
                    child: GameCard(),
                  );
                },
              ),
      ),
    );
  }
}
