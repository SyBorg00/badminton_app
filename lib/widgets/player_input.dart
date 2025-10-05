import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerInput extends StatefulWidget {
  final String? label;
  final TextEditingController controller;
  final TextInputType? type;
  final Icon? prefixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatter;

  const PlayerInput({
    super.key,
    this.label,
    required this.controller,
    this.type,
    this.prefixIcon,
    this.validator,
    this.inputFormatter,
  });

  @override
  State<PlayerInput> createState() => _PlayerInputState();
}

class _PlayerInputState extends State<PlayerInput> {
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    _focus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.type ?? TextInputType.text,
      inputFormatters: widget.inputFormatter,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        label: Text(widget.label ?? ''),
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const Color.fromARGB(255, 10, 165, 23);
          }
          return Colors.black;
        }),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(color: Color.fromARGB(255, 10, 165, 23));
          }
          return const TextStyle(color: Colors.black);
        }),
        errorStyle: const TextStyle(height: 0),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _focus.hasFocus ? Colors.black : Colors.red,
            width: 1.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 10, 165, 23),
            width: 2,
          ),
        ),
      ),

      validator: widget.validator,
    );
  }
}
