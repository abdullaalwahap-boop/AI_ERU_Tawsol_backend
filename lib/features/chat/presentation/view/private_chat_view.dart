import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo_impl.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/private_chat_cubit/private_chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/app_bar/chat_app_bar.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/private_chat_body.dart';

class PrivateChatView extends StatelessWidget {
  final ChatConversation conversation;

  const PrivateChatView({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrivateChatCubit(ChatRepoImpl())
        ..loadMessages(conversation.otherUser.id),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: ChatAppBar(user: conversation.otherUser),
          body: PrivateChatBody(conversation: conversation),
        ),
      ),
    );
  }
}
