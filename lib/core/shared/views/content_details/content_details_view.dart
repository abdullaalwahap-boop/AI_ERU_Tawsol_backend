import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/events/announcement_change_notifier.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/shared/models/content_display_item.dart';
import 'package:ai_eru_tawasol/core/shared/views/content_details/widgets/content_details_app_bar.dart';
import 'package:ai_eru_tawasol/core/shared/views/content_details/widgets/content_details_header_card.dart';
import 'package:ai_eru_tawasol/core/shared/views/content_details/widgets/content_details_letter_body.dart';
import 'package:ai_eru_tawasol/core/shared/views/content_details/widgets/content_details_attachments_section.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';

class ContentDetailsView extends StatefulWidget {
  final ContentDisplayItem item;

  const ContentDetailsView({super.key, required this.item});

  @override
  State<ContentDetailsView> createState() => _ContentDetailsViewState();
}

class _ContentDetailsViewState extends State<ContentDetailsView> {
  @override
  void initState() {
    super.initState();
    _markRead();
  }

  void _markRead() {
    final id = int.tryParse(widget.item.id);
    if (id == null) return;
    // Fire-and-forget: backend marks as read, notifier updates all listeners
    getIt<AnnounRepo>().markRead(id).catchError((_) {});
    getIt<AnnouncementChangeNotifier>().notifyMarkRead(widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            ContentDetailsAppBar(item: widget.item),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentDetailsHeaderCard(item: widget.item),
                    AppSpacing.h20,
                    ContentDetailsLetterBody(item: widget.item),
                    if (widget.item.attachments.isNotEmpty) ...[
                      AppSpacing.h20,
                      ContentDetailsAttachmentsSection(
                          attachments: widget.item.attachments),
                    ],
                    AppSpacing.h16,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
