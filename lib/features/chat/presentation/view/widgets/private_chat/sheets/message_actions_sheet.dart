import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

class MessageActionsSheet extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onReply;
  final VoidCallback? onCopy;
  final void Function(String newText) onEdit;
  final VoidCallback onDelete;

  const MessageActionsSheet({
    super.key,
    required this.message,
    required this.onReply,
    this.onCopy,
    required this.onEdit,
    required this.onDelete,
  });

  void _handleReply(BuildContext context) {
    Navigator.pop(context);
    onReply();
  }

  void _handleCopy(BuildContext context) {
    Navigator.pop(context);
    onCopy?.call();
  }

  void _handleEdit(BuildContext context) {
    Navigator.pop(context);
    _showEditDialog(context);
  }

  void _handleDelete(BuildContext context) {
    Navigator.pop(context);
    onDelete();
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final confirmed = await showDialog<String>(
      context: context,
      builder: (ctx) => _EditMessageDialog(initialText: message.text ?? ''),
    );
    if (confirmed != null && confirmed != message.text) {
      onEdit(confirmed);
    }
  }

  bool get _hasDestructiveActions => message.canEdit || message.canDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.large,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),

          // Reply — always available for non-deleted messages
          _ActionTile(
            icon: Icons.reply_rounded,
            label: 'Reply',
            color: AppColors.primary,
            onTap: () => _handleReply(context),
          ),

          // Copy — only for text messages with content
          if (onCopy != null)
            _ActionTile(
              icon: Icons.copy_rounded,
              label: 'Copy message',
              color: AppColors.textSecondary,
              onTap: () => _handleCopy(context),
            ),

          // Divider between safe and destructive actions
          if (_hasDestructiveActions)
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.dividerLight,
            ),

          if (message.canEdit)
            _ActionTile(
              icon: Icons.edit_rounded,
              label: 'Edit message',
              color: AppColors.primary,
              onTap: () => _handleEdit(context),
            ),

          if (message.canEdit && message.canDelete)
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.dividerLight,
            ),

          if (message.canDelete)
            _ActionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete message',
              color: AppColors.error,
              onTap: () => _handleDelete(context),
            ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Edit dialog ──────────────────────────────────────────────────────────────

class _EditMessageDialog extends StatefulWidget {
  final String initialText;

  const _EditMessageDialog({required this.initialText});

  @override
  State<_EditMessageDialog> createState() => _EditMessageDialogState();
}

class _EditMessageDialogState extends State<_EditMessageDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      title: Text(
        'Edit message',
        style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: 'Edit your message…',
          hintStyle:
              AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          filled: true,
          fillColor: AppColors.inputBgLight,
          border: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
        ),
        style:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            final text = _controller.text.trim();
            Navigator.pop(context, text.isNotEmpty ? text : null);
          },
          child: Text(
            'Save',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Action tile ──────────────────────────────────────────────────────────────

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.medium,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
