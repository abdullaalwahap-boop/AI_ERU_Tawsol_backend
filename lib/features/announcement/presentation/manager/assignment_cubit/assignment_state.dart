part of 'assignment_cubit.dart';

sealed class AssignmentState extends Equatable {
  const AssignmentState();
  @override
  List<Object?> get props => [];
}

final class AssignmentInitial extends AssignmentState {}

final class AssignmentLoading extends AssignmentState {}

final class AssignmentActionLoading extends AssignmentState {}

final class AssignmentLoaded extends AssignmentState {
  final List<Assignment> assignments;
  final String? statusFilter;

  const AssignmentLoaded({
    required this.assignments,
    this.statusFilter,
  });

  List<Assignment> get filtered {
    if (statusFilter == null || statusFilter == 'all') return assignments;
    final now = DateTime.now();
    return switch (statusFilter) {
      'upcoming' => assignments.where((a) => a.deadline.isAfter(now)).toList(),
      'overdue' => assignments.where((a) => a.deadline.isBefore(now)).toList(),
      _ => assignments,
    };
  }

  @override
  List<Object?> get props => [assignments, statusFilter];

  AssignmentLoaded copyWith({
    List<Assignment>? assignments,
    String? statusFilter,
    bool clearStatus = false,
  }) =>
      AssignmentLoaded(
        assignments: assignments ?? this.assignments,
        statusFilter:
            clearStatus ? null : (statusFilter ?? this.statusFilter),
      );
}

final class AssignmentError extends AssignmentState {
  final String message;
  const AssignmentError(this.message);
  @override
  List<Object?> get props => [message];
}
