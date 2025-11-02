import 'package:badminton_app/game_list.dart';
import 'package:badminton_app/player_list.dart';
import 'package:badminton_app/user_settings.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [PlayerList(), GameList(), UserSettings()];

  void _onClickedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person)),
          BottomNavigationBarItem(icon: Icon(Icons.person_2)),
          BottomNavigationBarItem(icon: Icon(Icons.settings)),
        ],
        currentIndex: _selectedIndex,
        onTap: _onClickedTab,
      ),
    );
  }
}
