import 'package:badminton_app/model/games.dart';
import 'package:badminton_app/widgets/app_input.dart';
import 'package:badminton_app/widgets/court_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameEdit extends StatefulWidget {
  final Games? game;
  final void Function(Games game) onEditGame;
  const GameEdit({super.key, required this.onEditGame, this.game});

  @override
  State<GameEdit> createState() => _GameEditState();
}

class _GameEditState extends State<GameEdit> {
  final _key = GlobalKey<FormState>();
  final _gameTitleController = TextEditingController();
  final _courtNameController = TextEditingController();
  final _courtRateController = TextEditingController();
  final shuttlecockPriceController = TextEditingController();
  bool isDivided = true;
  List<CourtSection?> section = [];

  @override
  void initState() {
    super.initState();
    if (widget.game != null) {
      final game = widget.game!;
      _gameTitleController.text = game.title;
      _courtNameController.text = game.court.courtName;
      _courtRateController.text = game.court.courtRate.toString();
      shuttlecockPriceController.text = game.court.shuttlecockPrice.toString();
      isDivided = game.court.isDivided;
      section = game.court.section;
    }
  }

  //deletion confirmation
  Future<void> _confirmDelete() async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Game'),
            content: const Text('Are you sure you want to delete this game?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
    if (!mounted) return;
    if (confirm) {
      Navigator.pop(context, 'delete');
    }
  }

  //for any changes in the checkbox
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

  bool _hasNoDateSchedule() {
    for (final sect in section) {
      final schedule = sect?.schedule;
      if (schedule?.start == null || schedule?.end == null) {
        return true;
      }
    }
    return false;
  }

  //submitting the data
  void _submitGameData() {
    //check if there are empty fields
    final isValid = _key.currentState?.validate() ?? false;
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix validation errors")),
      );
      return;
    } else if (_hasNoDateSchedule()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Some values in the schedule are missing"),
        ),
      );
      return;
    } else {
      final updatedGame = Games(
        id: widget.game?.id ?? DateTime.now().toString(),
        title: _gameTitleController.text,
        court: GameCourt(
          courtName: _courtNameController.text,
          courtRate: double.parse(_courtRateController.text),
          shuttlecockPrice: double.parse(shuttlecockPriceController.text),
          isDivided: isDivided,
          section: section,
        ),
      );
      Navigator.pop(context, updatedGame);
    }
  }

  @override
  void dispose() {
    _gameTitleController.dispose();
    _courtNameController.dispose();
    _courtRateController.dispose();
    shuttlecockPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Game"),
        actions: [
          TextButton(
            onPressed: _submitGameData,
            child: const Text(
              "SAVE",
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          if (widget.game != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _key,
            child: ListView(
              children: [
                AppInput(
                  controller: _gameTitleController,
                  label: 'Game Title',
                  prefixIcon: const Icon(Icons.title),
                ),
                const SizedBox(height: 30),
                AppInput(
                  controller: _courtNameController,
                  label: 'Game Court',
                  validator: _validateNotEmpty,
                  prefixIcon: const Icon(Icons.sports),
                ),
                const SizedBox(height: 30),
                AppInput(
                  controller: _courtRateController,
                  label: 'Court Rate (₱)',
                  validator: _validateNotEmpty,
                  type: TextInputType.number,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  prefixIcon: const Icon(Icons.rate_review),
                ),
                const SizedBox(height: 30),
                AppInput(
                  controller: shuttlecockPriceController,
                  label: 'Shuttlecock Price (₱)',
                  validator: _validateNotEmpty,
                  type: TextInputType.number,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  prefixIcon: const Icon(Icons.price_change),
                ),
                const SizedBox(height: 30),
                CheckboxListTile(
                  title: const Text('Divide the court equally among players?'),
                  value: isDivided,
                  checkboxScaleFactor: 1.5,
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  onChanged: handleCheckboxChange,
                ),
                const SizedBox(height: 30),
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
      ),
    );
  }
}
