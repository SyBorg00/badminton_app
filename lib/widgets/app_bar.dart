import 'package:flutter/material.dart';

class BadmintonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final PreferredSize? bottom;
  final List<Widget>? actions;

  const BadmintonAppBar({super.key, this.title, this.actions, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Image.asset('images/badminton_logo_white.png'),
      title: title,
      actions: actions,
      backgroundColor: Colors.green,
      bottom: bottom,
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
