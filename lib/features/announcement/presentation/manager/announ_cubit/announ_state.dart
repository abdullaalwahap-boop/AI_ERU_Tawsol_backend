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

  const AnnounLoaded({
    required this.primary,
    this.secondary = const [],
    this.activeTab = AnnounTab.mine,
    this.activeFilter,
  });

  List<Announcement> get current {
    if (activeTab == AnnounTab.admin) return secondary;
    if (activeFilter == null) return primary;
    return primary.where((a) => a.type == activeFilter).toList();
  }

  @override
  List<Object?> get props => [primary, secondary, activeTab, activeFilter];

  AnnounLoaded copyWith({
    List<Announcement>? primary,
    List<Announcement>? secondary,
    AnnounTab? activeTab,
    AnnouncementType? activeFilter,
    bool clearFilter = false,
  }) {
    return AnnounLoaded(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      activeTab: activeTab ?? this.activeTab,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
    );
  }
}

final class AnnounError extends AnnounState {
  final String message;

  const AnnounError(this.message);

  @override
  List<Object?> get props => [message];
}
