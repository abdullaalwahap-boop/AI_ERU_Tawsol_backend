import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/sheets/edit_message_dialog.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/sheets/message_action_tile.dart';

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
      builder: (ctx) =>
          EditMessageDialog(initialText: message.text ?? ''),
    );
    if (confirmed != null && confirmed != message.text) {
      onEdit(confirmed);
    }
  }

  bool get _hasDestructiveActions => message.canEdit || message.canDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: context.colorSurface,
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
              color: context.colorDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          MessageActionTile(
            icon: Icons.reply_rounded,
            label: l10n.reply,
            color: AppColors.primary,
            onTap: () => _handleReply(context),
          ),
          if (onCopy != null)
            MessageActionTile(
              icon: Icons.copy_rounded,
              label: l10n.copyMessage,
              color: context.colorTextSecondary,
              onTap: () => _handleCopy(context),
            ),
          if (_hasDestructiveActions)
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: context.colorDivider,
            ),
          if (message.canEdit)
            MessageActionTile(
              icon: Icons.edit_rounded,
              label: l10n.editMessageAction,
              color: AppColors.primary,
              onTap: () => _handleEdit(context),
            ),
          if (message.canEdit && message.canDelete)
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: context.colorDivider,
            ),
          if (message.canDelete)
            MessageActionTile(
              icon: Icons.delete_outline_rounded,
              label: l10n.deleteMessageAction,
              color: AppColors.error,
              onTap: () => _handleDelete(context),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
