import 'package:badminton_app/game_add.dart';
import 'package:badminton_app/game_view.dart';
import 'package:badminton_app/model/games.dart';
import 'package:badminton_app/model/players.dart';
import 'package:badminton_app/widgets/game_card.dart';
import 'package:flutter/material.dart';

class GameList extends StatefulWidget {
  final List<Games> gameList;
  final Function(Games game) onAddGame;
  final Function(Games game) onEditGame;
  final Function(Games game) onDeleteGame;
  final List<Players> players;

  const GameList({
    super.key,
    required this.gameList,
    required this.onAddGame,
    required this.onEditGame,
    required this.onDeleteGame,
    required this.players,
  });

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  late FocusNode _focus;
  final _searchGameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchGameController.addListener(_onSearchGame);
    _focus = FocusNode();
    _focus.addListener(() {
      setState(() {});
    });
    // Ensure filtered list reflects the initial game list
    filteredGameList = List.from(widget.gameList);
  }

  List<Games> filteredGameList = [];

  void _addGame(Games games) {
    widget.onAddGame(games);
    _onSearchGame(); // Recompute filtered list
  }

  void _editGame(Games games) {
    widget.onEditGame(games);
    _onSearchGame(); // Recompute filtered list
  }

  void _deleteGame(Games games) {
    widget.onDeleteGame(games);
    setState(() {
      filteredGameList.removeWhere((g) => g.id == games.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Game successfully deleted')),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Games games) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete "${games.title}"?',
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
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
      if (query.isEmpty) {
        // no query -> show all
        filteredGameList = List.from(widget.gameList);
      } else {
        filteredGameList = widget.gameList.where((game) {
          final title = game.title.toLowerCase();
          return title.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchGameController.removeListener(_onSearchGame);
    _searchGameController.dispose();
    _focus.dispose();
    super.dispose();
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
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
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
              iconSize: 50,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchGameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  label: const Text(
                    "Search by title",
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
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
                      return const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: Colors.green,
                      );
                    }
                    return const TextStyle(
                      color: Color.fromARGB(255, 57, 57, 57),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: filteredGameList.isEmpty
            ? (widget.gameList.isEmpty
                  ? const Text("No games listed yet")
                  : const Text("No matching games"))
            : ListView.builder(
                itemCount: filteredGameList.length,
                itemBuilder: (BuildContext context, int index) {
                  final games = filteredGameList[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Dismissible(
                      key: ValueKey(games.id),
                      direction: DismissDirection.horizontal,
                      confirmDismiss: (direction) =>
                          _confirmDelete(context, games),
                      onDismissed: (_) {
                        _deleteGame(games);
                      },
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => GameView(
                                games: games,
                                players: widget.players,
                              ),
                            ),
                          );

                          if (!mounted) return;

                          if (result == 'delete') {
                            _deleteGame(games);
                          } else if (result is Games) {
                            widget.onEditGame(result);
                            _editGame(games);
                          }
                        },
                        child: GameCard(
                          games: games,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
