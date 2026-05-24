import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/skeleton/skeleton_bone.dart';

class CourseSkeletonContent extends StatelessWidget {
  const CourseSkeletonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            SkeletonBone(width: 54, height: 54, radius: 14),
            AppSpacing.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBone(width: double.infinity, height: 13, radius: 6),
                  AppSpacing.h6,
                  SkeletonBone(width: 60, height: 20, radius: 6),
                  AppSpacing.h6,
                  SkeletonBone(width: 130, height: 11, radius: 5),
                ],
              ),
            ),
            AppSpacing.w8,
            SkeletonBone(width: 20, height: 20, radius: 10),
          ],
        ),
        AppSpacing.h12,
        const SkeletonBone(width: double.infinity, height: 1, radius: 1),
        AppSpacing.h10,
        const Row(
          children: [
            SkeletonBone(width: 88, height: 24, radius: 12),
            AppSpacing.w8,
            SkeletonBone(width: 72, height: 24, radius: 12),
            AppSpacing.w8,
            SkeletonBone(width: 64, height: 24, radius: 12),
          ],
        ),
      ],
    );
  }
}
