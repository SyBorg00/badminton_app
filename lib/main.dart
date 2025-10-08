import 'package:badminton_app/player_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PlayerList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
