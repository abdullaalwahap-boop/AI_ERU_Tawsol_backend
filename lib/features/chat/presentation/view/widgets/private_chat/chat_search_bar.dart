import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class ChatSearchBar extends StatefulWidget {
  final void Function(String query) onChanged;
  final VoidCallback onClose;

  const ChatSearchBar({
    super.key,
    required this.onChanged,
    required this.onClose,
  });

  @override
  State<ChatSearchBar> createState() => _ChatSearchBarState();
}

class _ChatSearchBarState extends State<ChatSearchBar> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  void _close() {
    _controller.clear();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(4, 8, 12, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: _close,
          ),
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                controller: _controller,
                autofocus: true,
                style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search messages…',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white54),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 9),
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty) ...[
            AppSpacing.w4,
            GestureDetector(
              onTap: _clear,
              child: const Icon(Icons.close_rounded,
                  color: Colors.white70, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
