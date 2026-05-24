import 'package:ai_eru_tawasol/core/session/app_role.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/announ_view.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/chat_view.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/course_view.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';

List<Widget> buildPages(AppRole role) => [
      AnnounView(role: role.toAnnounRole),
      const ChatView(),
      CourseView(role: role.toCourseRole),
      const ProfileView(),
    ];
