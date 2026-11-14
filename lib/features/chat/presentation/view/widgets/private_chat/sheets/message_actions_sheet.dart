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
  final VoidCallback? onDelete;
  final VoidCallback? onDeleteForMe;
  final VoidCallback? onDeleteForEveryone;

  const MessageActionsSheet({
    super.key,
    required this.message,
    required this.onReply,
    this.onCopy,
    required this.onEdit,
    this.onDelete,
    this.onDeleteForMe,
    this.onDeleteForEveryone,
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

  Future<void> _handleDelete(BuildContext context) async {
    Navigator.pop(context);
    final l10n = AppLocalizations.of(context);
    final isMe = message.isFromMe;

    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            l10n.deleteMessageAction,
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.0),
          ),
          content: Text(
            isMe
                ? (isAr
                    ? 'هل ترغب في حذف الرسالة لديك فقط أم لدى الجميع؟'
                    : 'Do you want to delete this message for you only or for everyone?')
                : (isAr
                    ? 'هل ترغب في حذف هذه الرسالة من محادثتك؟'
                    : 'Do you want to delete this message from your chat?'),
            textAlign: TextAlign.start,
            style: const TextStyle(letterSpacing: 0.0),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'cancel'),
              child: Text(l10n.cancel, style: const TextStyle(letterSpacing: 0.0)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'for_me'),
              child: Text(
                isAr ? 'حذف لدي فقط' : 'Delete for me',
                style: const TextStyle(color: AppColors.error, letterSpacing: 0.0),
              ),
            ),
            if (isMe)
              TextButton(
                onPressed: () => Navigator.pop(ctx, 'for_everyone'),
                child: Text(
                  isAr ? 'حذف لدى الجميع' : 'Delete for everyone',
                  style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, letterSpacing: 0.0),
                ),
              ),
          ],
        ),
      ),
    );

    if (action == 'for_me') {
      if (onDeleteForMe != null) {
        onDeleteForMe!();
      } else {
        onDelete?.call();
      }
    } else if (action == 'for_everyone') {
      if (onDeleteForEveryone != null) {
        onDeleteForEveryone!();
      } else {
        onDelete?.call();
      }
    }
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
