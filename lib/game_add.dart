import 'package:badminton_app/model/games.dart';
import 'package:badminton_app/widgets/app_input.dart';
import 'package:badminton_app/widgets/court_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final shuttlecockPriceController = TextEditingController();
  bool isDivided = true;
  List<CourtSection?> section = [];

  @override
  void initState() {
    super.initState();
    _loadDefaultSettings();
  }

  //for any changes in the checkbox
  void handleCheckboxChange(bool? value) {
    setState(() {
      isDivided = value ?? false;
    });
  }

  //load default settings in the user_settings.dart
  Future<void> _loadDefaultSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _courtNameController.text = prefs.getString('defaultCourtName') ?? '';
      _courtRateController.text =
          prefs.getDouble('defaultCourtRate')?.toString() ?? '';
      shuttlecockPriceController.text =
          prefs.getDouble('defaultShuttleCockPrice')?.toString() ?? '';
      isDivided = prefs.getBool('divideCourtPerPlayer') ?? true;
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
      widget.onAddGame(
        Games(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: _gameTitleController.text,
          court: GameCourt(
            courtName: _courtNameController.text,
            courtRate: double.parse(_courtRateController.text),
            shuttlecockPrice: double.parse(shuttlecockPriceController.text),
            section: section,
            isDivided: isDivided,
          ),
        ),
      );
      Navigator.pop(context);
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
        title: const Text("New Game"),
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
                  label: 'Court Rate',
                  validator: _validateNotEmpty,
                  type: TextInputType.number,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  prefixIcon: const Icon(Icons.rate_review),
                ),
                const SizedBox(height: 30),
                AppInput(
                  controller: shuttlecockPriceController,
                  label: 'Shuttlecock Price',
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
