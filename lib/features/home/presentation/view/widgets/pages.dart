import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/announ_view.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/chat_view.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/course_view.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';

CourseRole _courseRoleFrom(AnnounRole role) {
  switch (role) {
    case AnnounRole.student:
      return CourseRole.student;
    case AnnounRole.doctor:
    case AnnounRole.admin:
      return CourseRole.doctor;
  }
}

List<Widget> buildPages(AnnounRole role) => [
      AnnounView(role: role),
      const ChatView(),
      CourseView(role: _courseRoleFrom(role)),
      const ProfileView(),
    ];
