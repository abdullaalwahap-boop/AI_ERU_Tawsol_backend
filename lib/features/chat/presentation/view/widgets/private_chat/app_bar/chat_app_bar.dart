import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/private_chat_cubit/private_chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/app_bar/chat_app_bar_avatar.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/app_bar/chat_app_bar_user_info.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChatUser user;

  const ChatAppBar({super.key, required this.user});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x22003096),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              ChatAppBarAvatar(user: user),
              AppSpacing.w10,
              Expanded(child: ChatAppBarUserInfo(user: user)),
              IconButton(
                icon: const Icon(Icons.search_rounded,
                    color: Colors.white, size: 22),
                onPressed: () =>
                    context.read<PrivateChatCubit>().toggleSearch(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
