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
  final _key = GlobalKey<FormState>();
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

  //for any empty fields
  String? _validateNotEmpty(String? val) {
    if (val == null || val.trim().isEmpty) return 'Please fill this field';
    return null;
  }

  void _submitGameData() {
    //check if there are empty fields
    final isValid = _key.currentState?.validate() ?? false;
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix validation errors")),
      );
      return;
    } else {
      widget.onAddGame(
        Games(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: _gameTitleController.text,
          playerCount: 0,
          total: 0,
          court: GameCourt(
            courtName: _courtNameController.text,
            courtRate: double.parse(_courtRateController.text),
            shottlecockPrice: double.parse(_courtRateController.text),
            section: section,
            isDivided: isDivided,
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Game"),
        actions: [
          TextButton(
            onPressed: _submitGameData,
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
          key: _key,
          child: ListView(
            children: [
              AppInput(controller: _gameTitleController, label: 'Game Title'),
              AppInput(
                controller: _courtNameController,
                label: 'Game Court',
                validator: _validateNotEmpty,
              ),

              AppInput(
                controller: _courtRateController,
                label: 'Court Rate',
                validator: _validateNotEmpty,
                type: TextInputType.number,
              ),
              AppInput(
                controller: _shottlecockPriceController,
                label: 'Shuttlecock Price',
                validator: _validateNotEmpty,
                type: TextInputType.number,
              ),
              CheckboxListTile(
                title: const Text('Divide the court equally among players?'),
                value: isDivided,
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
