import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class ChatSearchBar extends StatefulWidget {
  final void Function(String query) onChanged;
  final VoidCallback onClose;

  /// Total number of matching messages (0 when no query or no matches).
  final int resultCount;

  /// 1-based position of the focused result (null when resultCount == 0).
  final int? currentPosition;

  /// Navigate to a newer result (position--). Null when already at newest.
  final VoidCallback? onPrev;

  /// Navigate to an older result (position++). Null when already at oldest.
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
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: _close,
          ),

          // Search field
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
                style:
                    AppTextStyles.bodyMedium.copyWith(color: Colors.white),
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

          // Clear button
          if (hasQuery) ...[
            AppSpacing.w4,
            GestureDetector(
              onTap: _clear,
              child: const Icon(Icons.close_rounded,
                  color: Colors.white70, size: 20),
            ),
          ],

          // Navigation block (shown only when there are results)
          if (hasQuery && hasResults) ...[
            AppSpacing.w8,
            _NavBlock(
              currentPosition: widget.currentPosition!,
              resultCount: widget.resultCount,
              onPrev: widget.onPrev,
              onNext: widget.onNext,
            ),
          ],

          // No results indicator
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

class _NavBlock extends StatelessWidget {
  final int currentPosition;
  final int resultCount;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _NavBlock({
    required this.currentPosition,
    required this.resultCount,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up arrow — go to newer result
        _NavButton(
          icon: Icons.keyboard_arrow_up_rounded,
          onTap: onPrev,
        ),
        // Down arrow — go to older result
        _NavButton(
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: onNext,
        ),
        AppSpacing.w4,
        Text(
          '$currentPosition / $resultCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _NavButton({required this.icon, this.onTap});

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
