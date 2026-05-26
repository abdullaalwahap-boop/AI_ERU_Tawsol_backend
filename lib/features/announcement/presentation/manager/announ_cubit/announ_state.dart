part of 'announ_cubit.dart';

sealed class AnnounState extends Equatable {
  const AnnounState();

  @override
  List<Object?> get props => [];
}

final class AnnounInitial extends AnnounState {}

final class AnnounLoading extends AnnounState {}

final class AnnounLoaded extends AnnounState {
  final List<Announcement> primary;
  final List<Announcement> secondary;
  final AnnounTab activeTab;
  final AnnouncementType? activeFilter;
  final AnnouncementPriority? priorityFilter;

  const AnnounLoaded({
    required this.primary,
    this.secondary = const [],
    this.activeTab = AnnounTab.mine,
    this.activeFilter,
    this.priorityFilter,
  });

  List<Announcement> get current {
    List<Announcement> list =
        activeTab == AnnounTab.admin ? secondary : primary;
    if (activeFilter != null) {
      list = list.where((a) => a.type == activeFilter).toList();
    }
    if (priorityFilter != null) {
      list = list.where((a) => a.priority == priorityFilter).toList();
    }
    return list;
  }

  @override
  List<Object?> get props =>
      [primary, secondary, activeTab, activeFilter, priorityFilter];

  AnnounLoaded copyWith({
    List<Announcement>? primary,
    List<Announcement>? secondary,
    AnnounTab? activeTab,
    AnnouncementPriority? priorityFilter,
    AnnouncementType? activeFilter,
    bool clearFilter = false,
    bool clearPriorityFilter = false,
  }) {
    return AnnounLoaded(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      activeTab: activeTab ?? this.activeTab,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
      priorityFilter: clearPriorityFilter
          ? null
          : (priorityFilter ?? this.priorityFilter),
    );
  }
}

final class AnnounError extends AnnounState {
  final String message;

  const AnnounError(this.message);

  @override
  List<Object?> get props => [message];
}
