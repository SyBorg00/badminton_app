import 'package:flutter/material.dart';
import 'package:badminton_app/model/players.dart';
import 'package:badminton_app/player_add.dart';
import 'package:badminton_app/player_edit.dart';
import 'package:badminton_app/widgets/player_card.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({super.key});

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  late FocusNode _focus;
  final _searchNameController = TextEditingController();
  final List<Players> playerList = [
    Players(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nickName: "Tester1",
      fullName: "Terstert Mc Tester",
      mobileNumber: '09199557889',
      email: "wedontcare@gmail.com",
      address: "you wish",
      remarks: "BRUH",
      level: PlayerLevel(
        rank: RankRange(PlayerRank.intermediate, PlayerRank.levelD),
        strength: StrengthRange(PlayerStrength.weak, PlayerStrength.strong),
      ),
    ),
  ];

  List<Players> filteredPlayers = [];

  @override
  void initState() {
    super.initState();
    filteredPlayers = playerList;
    _searchNameController.addListener(_onSearchPlayer);
    _focus = FocusNode();
    _focus.addListener(() {
      setState(() {});
    });
  }

  void _onSearchPlayer() {
    final query = _searchNameController.text.toLowerCase();
    setState(() {
      filteredPlayers = playerList.where((player) {
        final nickname = player.nickName.toLowerCase();
        final fullName = player.fullName.toLowerCase();
        return nickname.contains(query) || fullName.contains(query);
      }).toList();
    });
  }

  //#region CRUD Function operations

  void _addPlayer(Players player) {
    setState(() {
      playerList.add(player);
    });
  }

  void _editPlayer(Players updatedPlayer) {
    setState(() {
      // Find player in full list
      final originalIndex = playerList.indexWhere(
        (p) => p.id == updatedPlayer.id,
      );

      if (originalIndex != -1) {
        playerList[originalIndex] = updatedPlayer;
      }

      // Also update filtered list if visible
      final filteredIndex = filteredPlayers.indexWhere(
        (p) => p.id == updatedPlayer.id,
      );

      if (filteredIndex != -1) {
        filteredPlayers[filteredIndex] = updatedPlayer;
      }
    });
  }

  void _deletePlayer(Players player) {
    setState(() {
      playerList.removeWhere((p) => p.id == player.id);
      filteredPlayers.removeWhere((p) => p.id == player.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Player successfully deleted')),
    );
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
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "All Players",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: _showAddPlayer,
              icon: const Icon(
                Icons.add_circle,
                color: Colors.green,
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
                controller: _searchNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  label: const Text(
                    "Search by name or nick name",
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
                  focusColor: Colors.green,
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
        child: Padding(
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
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 21, 255, 0),
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
