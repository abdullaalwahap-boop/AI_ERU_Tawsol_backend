import 'package:flutter/material.dart';

class ChatSearchNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const ChatSearchNavButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.white30,
          size: 24,
        ),
      ),
    );
  }
}
