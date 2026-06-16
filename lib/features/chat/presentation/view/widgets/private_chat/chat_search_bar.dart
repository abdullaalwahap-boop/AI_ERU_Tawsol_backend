import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/chat_search_nav_block.dart';

class ChatSearchBar extends StatefulWidget {
  final void Function(String query) onChanged;
  final VoidCallback onClose;
  final int resultCount;
  final int? currentPosition;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const ChatSearchBar({
    super.key,
    required this.onChanged,
    required this.onClose,
    this.resultCount = 0,
    this.currentPosition,
    this.onPrev,
    this.onNext,
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
    final hasQuery = _controller.text.isNotEmpty;
    final hasResults = widget.resultCount > 0;

    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 12),
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
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchMessages,
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white54),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 9),
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),
          if (hasQuery) ...[
            AppSpacing.w4,
            GestureDetector(
              onTap: _clear,
              child: const Icon(Icons.close_rounded,
                  color: Colors.white70, size: 20),
            ),
          ],
          if (hasQuery && hasResults) ...[
            AppSpacing.w8,
            ChatSearchNavBlock(
              currentPosition: widget.currentPosition!,
              resultCount: widget.resultCount,
              onPrev: widget.onPrev,
              onNext: widget.onNext,
            ),
          ],
          if (hasQuery && !hasResults) ...[
            AppSpacing.w8,
            Text(
              '0 / 0',
              style: AppTextStyles.labelSmall
                  .copyWith(color: Colors.white60),
            ),
          ],
        ],
      ),
    );
  }
}
