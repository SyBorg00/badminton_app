import 'package:flutter/material.dart';
import 'package:badminton_app/widgets/app_input.dart';
import 'package:badminton_app/widgets/player_level.dart';
import 'package:badminton_app/model/players.dart';
import 'package:flutter/services.dart';

class PlayerAdd extends StatefulWidget {
  final void Function(Players player) onAddPlayer;
  const PlayerAdd({super.key, required this.onAddPlayer});

  @override
  State<PlayerAdd> createState() => _PlayerAddState();
}

class _PlayerAddState extends State<PlayerAdd> {
  final _key = GlobalKey<FormState>(); //essential for the form widget
  final _nickNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _remarkController = TextEditingController();
  PlayerLevel? playerLevel;

  @override
  void initState() {
    super.initState();
    playerLevel = PlayerLevel(
      rank: RankRange(PlayerRank.levelF, PlayerRank.levelF),
      strength: StrengthRange(
        PlayerStrength.weak,
        PlayerStrength.strong,
      ),
    );
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _fullNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _submitPlayerData() {
    //check if there are empty fields
    final isValid = _key.currentState?.validate() ?? false;
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix validation errors")),
      );
      return;
    } else {
      widget.onAddPlayer(
        Players(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          nickName: _nickNameController.text,
          fullName: _fullNameController.text,
          mobileNumber: _mobileNumberController.text,
          email: _emailController.text,
          address: _addressController.text,
          remarks: _remarkController.text,
          level:
              playerLevel ??
              PlayerLevel(
                rank: RankRange(PlayerRank.levelF, PlayerRank.levelF),
                strength: StrengthRange(
                  PlayerStrength.weak,
                  PlayerStrength.strong,
                ),
              ),
        ),
      );
      Navigator.pop(context);
    }
  }

  //for any changes made by the slider widget
  void _onSliderChanged(PlayerLevel level) {
    setState(() {
      playerLevel = level;
    });
  }

  //for any empty fields
  String? _validateNotEmpty(String? val) {
    if (val == null || val.trim().isEmpty) return 'Please fill this field';
    return null;
  }

  //for email address validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  //for phone number validation
  String? _validatePhoneNum(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    final phoneRegex = RegExp(r'^\+?\d{7,15}$');
    if (!phoneRegex.hasMatch(value)) return 'Invalid phone number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Player"),
        actions: [
          TextButton(
            onPressed: _submitPlayerData,
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
            child: Column(
              children: [
                AppInput(
                  controller: _nickNameController,
                  label: 'NICKNAME',
                  validator: _validateNotEmpty,
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 30),
                AppInput(
                  controller: _fullNameController,
                  label: 'FULL NAME',
                  validator: _validateNotEmpty,
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 30),
                AppInput(
                  controller: _mobileNumberController,
                  type: TextInputType.phone,
                  label: 'MOBILE NUMBER',
                  validator: _validatePhoneNum,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  prefixIcon: const Icon(Icons.phone),
                ),
                const SizedBox(height: 30),
                AppInput(
                  controller: _emailController,
                  type: TextInputType.emailAddress,
                  label: 'EMAIL ADDRESS',
                  validator: _validateEmail,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 30),
                AppInput(
                  controller: _addressController,
                  type: TextInputType.multiline,
                  label: 'HOME ADDRESS',
                  validator: _validateNotEmpty,
                  prefixIcon: const Icon(Icons.home),
                ),
                const SizedBox(height: 30),
                AppInput(
                  controller: _remarkController,
                  type: TextInputType.multiline,
                  label: 'REMARKS',
                  validator: _validateNotEmpty,
                  prefixIcon: const Icon(Icons.book),
                ),
                const SizedBox(height: 30),
                PlayerLevelWidget(
                  level: playerLevel,
                  onSliderChanged: _onSliderChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
