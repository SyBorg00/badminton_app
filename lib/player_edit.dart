import 'package:flutter/material.dart';
import 'package:badminton_app/widgets/app_input.dart';
import 'package:badminton_app/widgets/player_level.dart';
import 'package:badminton_app/model/players.dart';
import 'package:flutter/services.dart';

class PlayerEdit extends StatefulWidget {
  final Players? player;
  final int index;
  const PlayerEdit({
    super.key,
    this.player,
    required this.index,
  });

  @override
  State<PlayerEdit> createState() => _PlayerEditState();
}

class _PlayerEditState extends State<PlayerEdit> {
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
    //for editing purposes
    if (widget.player != null) {
      final player = widget.player!;
      _nickNameController.text = player.nickName;
      _fullNameController.text = player.fullName;
      _mobileNumberController.text = player.mobileNumber;
      _emailController.text = player.email;
      _addressController.text = player.address;
      _remarkController.text = player.remarks;
      playerLevel = player.level;
    }
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

  Future<void> _confirmDelete() async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete "${widget.player!.fullName}"?',
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
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
    if (!mounted) return;

    if (confirm) {
      // Pop back with a null or a special flag to indicate deletion
      Navigator.pop(context, 'delete');
    }
  }

  void _submitPlayerData() {
    //check if there are empty fields
    final bool isEmpty =
        (_nickNameController.text.isEmpty ||
            _fullNameController.text.isEmpty ||
            _mobileNumberController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _addressController.text.isEmpty ||
            _remarkController.text.isEmpty)
        ? true
        : false;

    if (isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
    } else {
      final updatedPlayer = Players(
        id: widget.player!.id,
        nickName: _nickNameController.text,
        fullName: _fullNameController.text,
        mobileNumber: _mobileNumberController.text,
        email: _emailController.text,
        address: _addressController.text,
        remarks: _remarkController.text,
        level:
            playerLevel ??
            PlayerLevel(
              rank: RankRange(PlayerRank.levelE, PlayerRank.levelD),
              strength: StrengthRange(
                PlayerStrength.weak,
                PlayerStrength.strong,
              ),
            ),
      );
      Navigator.pop(context, updatedPlayer);
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
        title: const Text('Edit Player'),
        actions: [
          TextButton(
            onPressed: _submitPlayerData,
            child: const Text(
              "SAVE",
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          if (widget.player != null)
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
