import 'package:badminton_app/widgets/app_input.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final _defaultCourtName = TextEditingController();
  final _defaultCourtRate = TextEditingController();
  final _defaultShutttleCockPrice = TextEditingController();
  bool? divideCourtperPlayer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          child: Column(
            children: [
              AppInput(
                controller: _defaultCourtName,
                label: 'Default Court Name',
              ),
              AppInput(
                controller: _defaultCourtRate,
                label: 'Default Court Rate',
              ),
              AppInput(
                controller: _defaultShutttleCockPrice,
                label: 'Default Shuttle Cock Price',
              ),
              Checkbox(
                value: true,
                onChanged: (bool? value) {
                  setState(() {
                    divideCourtperPlayer = value;
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
