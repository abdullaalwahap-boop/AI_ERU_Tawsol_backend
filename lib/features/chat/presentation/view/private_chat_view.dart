import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/private_chat_cubit/private_chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/app_bar/chat_app_bar.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/private_chat_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivateChatView extends StatelessWidget {
  final ChatConversation conversation;

  /// Called just before the route pops with the last message in the
  /// conversation so that the chat list can sync immediately.
  final ValueChanged<ChatMessage?>? onLastMessageChanged;

  const PrivateChatView({
    super.key,
    required this.conversation,
    this.onLastMessageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrivateChatCubit(
        getIt<ChatRepo>(),
        getIt<ChatWebSocketService>(),
        getIt<SecureStorageService>(),
      )..loadMessages(conversation.otherUser.id),
      // Builder gives us a context that has access to PrivateChatCubit,
      // so PopScope can read the cubit state on back-navigation.
      child: Builder(
        builder: (ctx) => PopScope(
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (!didPop || onLastMessageChanged == null) return;
            final s = ctx.read<PrivateChatCubit>().state;
            final last = s is PrivateChatLoaded && s.messages.isNotEmpty
                ? s.messages.last
                : null;
            onLastMessageChanged!(last);
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Scaffold(
              backgroundColor: AppColors.backgroundLight,
              appBar: ChatAppBar(user: conversation.otherUser),
              body: PrivateChatBody(conversation: conversation),
            ),
          ),
        ),
      ),
    );
  }
}
