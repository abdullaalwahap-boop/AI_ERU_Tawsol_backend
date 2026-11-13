import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_nav_item.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.announcementUnreadCount = 0,
    this.chatUnreadCount = 0,
  });

  final int currentIndex;
  final void Function(int) onTap;
  final int announcementUnreadCount;
  final int chatUnreadCount;

  static const _primaryColor = Color(0xff003096);
  static const _inactiveColor = Color(0xffA0AABB);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      HomeNavItem(
        icon: Icons.campaign_rounded,
        label: l10n.announcements,
        badgeCount: announcementUnreadCount,
      ),
      HomeNavItem(
        icon: Icons.chat_bubble_rounded,
        label: l10n.chat,
        badgeCount: chatUnreadCount,
      ),
      HomeNavItem(icon: Icons.menu_book_rounded, label: l10n.courses),
      HomeNavItem(icon: Icons.person_rounded, label: l10n.profile),
    ];
    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: selected
                                ? _primaryColor.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                items[i].icon,
                                size: 22,
                                color: selected ? _primaryColor : _inactiveColor,
                              ),
                              if (items[i].badgeCount > 0)
                                Positioned(
                                  top: -4,
                                  right: -8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: const BoxConstraints(
                                        minWidth: 16, minHeight: 16),
                                    child: Text(
                                      items[i].badgeCount > 99
                                          ? '99+'
                                          : '${items[i].badgeCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        AppSpacing.h3,
                        Text(
                          items[i].label,
                          style: AppTextStyles.overline.copyWith(
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected ? _primaryColor : _inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

