import 'package:equatable/equatable.dart';

import '../../domain/entities/submission.dart';

class SubmissionsState extends Equatable {
  const SubmissionsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  final List<Submission> items;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  SubmissionsState copyWith({
    List<Submission>? items,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? searchQuery,
  }) {
    return SubmissionsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, error, searchQuery];
}
