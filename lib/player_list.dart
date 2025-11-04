import 'package:flutter/material.dart';
import 'package:badminton_app/model/players.dart';
import 'package:badminton_app/player_add.dart';
import 'package:badminton_app/player_edit.dart';
import 'package:badminton_app/widgets/player_card.dart';

class PlayerList extends StatefulWidget {
  final List<Players> playerList;
  final Function(Players player) onAddPlayer;
  final Function(Players player) onEditPlayer;
  final Function(Players player) onDeletePlayer;

  const PlayerList({
    super.key,
    required this.playerList,
    required this.onAddPlayer,
    required this.onEditPlayer,
    required this.onDeletePlayer,
  });

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  late FocusNode _focus;
  final _searchNameController = TextEditingController();

  List<Players> filteredPlayers = [];

  @override
  void initState() {
    super.initState();
    filteredPlayers = List.from(widget.playerList);
    _searchNameController.addListener(_onSearchPlayer);
    _focus = FocusNode();
    _focus.addListener(() {
      setState(() {});
    });
  }

  void _onSearchPlayer() {
    final query = _searchNameController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredPlayers = List.from(widget.playerList);
      } else {
        filteredPlayers = widget.playerList.where((player) {
          final nickname = player.nickName.toLowerCase();
          final fullName = player.fullName.toLowerCase();
          return nickname.contains(query) || fullName.contains(query);
        }).toList();
      }
    });
  }

  //#region CRUD Function operations
  void _addPlayer(Players player) {
    widget.onAddPlayer(player);
    _onSearchPlayer(); // Refresh filtered list
  }

  void _editPlayer(Players updatedPlayer) {
    widget.onEditPlayer(updatedPlayer);
    _onSearchPlayer(); // Refresh filtered list
  }

  void _deletePlayer(Players player) {
    widget.onDeletePlayer(player);
    setState(() {
      filteredPlayers.removeWhere((p) => p.id == player.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Player successfully deleted')),
    );
  }

  @override
  void dispose() {
    _searchNameController.removeListener(_onSearchPlayer);
    _searchNameController.dispose();
    _focus.dispose();
    super.dispose();
  }
  //#endregion

  void _showAddPlayer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PlayerAdd(onAddPlayer: _addPlayer),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Players player) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete "${player.fullName}"?',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Image.asset('images/badminton_logo_white.png'),
        title: const Text(
          "All Players",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: _showAddPlayer,
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
                controller: _searchNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  label: const Text(
                    "Search by name or nick name",
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
        child: filteredPlayers.isEmpty
            ? const Text("The list is empty")
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  itemCount: filteredPlayers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Dismissible(
                        key: ValueKey(filteredPlayers[index]),
                        direction: DismissDirection.horizontal,
                        confirmDismiss: (direction) =>
                            _confirmDelete(context, filteredPlayers[index]),
                        onDismissed: (_) => {
                          setState(() {
                            filteredPlayers.removeAt(index);
                          }),
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Player successfully deleted'),
                            ),
                          ),
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
                                builder: (ctx) => PlayerEdit(
                                  player: filteredPlayers[index],
                                  index: index,
                                ),
                              ),
                            );

                            if (!mounted || result == null) return;

                            if (result is Players) {
                              _editPlayer(result);
                            } else if (result == 'delete') {
                              _deletePlayer(filteredPlayers[index]);
                            }
                          },
                          child: PlayerCard(player: filteredPlayers[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
