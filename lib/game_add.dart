import 'package:badminton_app/model/games.dart';
import 'package:badminton_app/widgets/app_input.dart';
import 'package:badminton_app/widgets/court_section.dart';
import 'package:flutter/material.dart';

class GameAdd extends StatefulWidget {
  final void Function(Games game) onAddGame;
  const GameAdd({super.key, required this.onAddGame});

  @override
  State<GameAdd> createState() => _GameAddState();
}

class _GameAddState extends State<GameAdd> {
  final _gameTitleController = TextEditingController();
  final _courtNameController = TextEditingController();
  final _courtRateController = TextEditingController();
  final _shottlecockPriceController = TextEditingController();
  bool isDivided = true;
  List<CourtSection?> section = [];

  void handleCheckboxChange(bool? value) {
    setState(() {
      isDivided = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Game"),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Add",
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Center(
        child: Form(
          child: ListView(
            children: [
              AppInput(controller: _gameTitleController, label: 'Game Title'),
              AppInput(
                controller: _courtNameController,
                label: 'Game Court',
              ),

              AppInput(
                controller: _courtRateController,
                label: 'Court Rate',
              ),
              AppInput(
                controller: _shottlecockPriceController,
                label: 'Shuttlecock Price',
              ),
              Checkbox(
                value: true,
                onChanged: handleCheckboxChange,
              ),
              CourtSectionWidget(
                section: section,
                onSectionChanged: (updatedSections) {
                  setState(() {
                    section = updatedSections;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
