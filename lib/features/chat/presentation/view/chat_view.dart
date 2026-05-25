import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/chat_cubit/chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/chat_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        getIt<ChatRepo>(),
        getIt<ChatWebSocketService>(),
        getIt<SecureStorageService>(),
      )..loadConversations(),
      child: const ChatViewBody(),
    );
  }
}
