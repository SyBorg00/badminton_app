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
  late FocusNode _focus;
  final _searchGameController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _searchGameController.addListener(_onSearchGame);
  }

  List<Games> filteredGameList = [];

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

  void _onSearchGame() {
    final query = _searchGameController.text.toLowerCase();
    setState(() {
      filteredGameList = gameList.where((game) {
        final title = game.title.toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Image.asset('images/badminton_logo_white.png'),
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "All Games",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: _showAddGame,
              icon: const Icon(
                Icons.add_circle,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              iconSize: 40,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _searchGameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  label: const Text(
                    "Search by title",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 20, 148, 58),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 57, 158, 37),
                      width: 2,
                    ),
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return const Color.fromARGB(255, 10, 165, 23);
                    }
                    return Colors.black;
                  }),
                  floatingLabelStyle: WidgetStateTextStyle.resolveWith((
                    states,
                  ) {
                    if (states.contains(WidgetState.focused)) {
                      return const TextStyle(color: Colors.green);
                    }
                    return const TextStyle(color: Colors.black);
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
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
