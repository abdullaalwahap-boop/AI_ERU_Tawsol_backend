import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';

class ChatMessageNoResults extends StatelessWidget {
  final String query;

  const ChatMessageNoResults({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Color(0xffA0AABB),
          ),
          AppSpacing.h12,
          Text(
            'No messages found for "$query"',
            style: const TextStyle(color: Color(0xff64748B), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
