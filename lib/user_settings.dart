import 'package:badminton_app/widgets/app_input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final _defaultCourtName = TextEditingController();
  final _defaultCourtRate = TextEditingController();
  final _defaultShuttleCockPrice = TextEditingController();
  bool divideCourtPerPlayer = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultCourtName.text = prefs.getString('defaultCourtName') ?? '';
      _defaultCourtRate.text =
          prefs.getDouble('defaultCourtRate')?.toString() ?? '';
      _defaultShuttleCockPrice.text =
          prefs.getDouble('defaultShuttleCockPrice')?.toString() ?? '';
      divideCourtPerPlayer = prefs.getBool('divideCourtPerPlayer') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultCourtName', _defaultCourtName.text);
    await prefs.setDouble(
      'defaultCourtRate',
      double.tryParse(_defaultCourtRate.text) ?? 0,
    );
    await prefs.setDouble(
      'defaultShuttleCockPrice',
      double.tryParse(_defaultShuttleCockPrice.text) ?? 0,
    );
    await prefs.setBool('divideCourtPerPlayer', divideCourtPerPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "User Settings",
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        leading: Image.asset('images/badminton_logo_white.png'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppInput(
                controller: _defaultCourtName,
                label: 'Default Court Name',
              ),
              const SizedBox(height: 10),
              AppInput(
                controller: _defaultCourtRate,
                label: 'Default Court Rate',
                type: TextInputType.number,
              ),
              const SizedBox(height: 10),
              AppInput(
                controller: _defaultShuttleCockPrice,
                label: 'Default Shuttlecock Price',
                type: TextInputType.number,
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Divide the court equally among players?'),
                checkboxScaleFactor: 1.5,
                checkColor: Colors.white,
                activeColor: Colors.green,
                value: divideCourtPerPlayer,
                onChanged: (bool? value) {
                  setState(() {
                    divideCourtPerPlayer = value ?? true;
                  });
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await _saveSettings();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings saved successfully!'),
                      ),
                    );
                  }
                },

                child: const Text('Save Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
