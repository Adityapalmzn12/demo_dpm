import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/submission_status.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final SubmissionStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color background;
    late final Color foreground;

    switch (status) {
      case SubmissionStatus.active:
        background = AppColors.chipActive;
        foreground = AppColors.purple;
      case SubmissionStatus.draft:
        background = AppColors.chipDraft;
        foreground = AppColors.draftAccent;
      case SubmissionStatus.trashed:
        background = AppColors.chipTrash;
        foreground = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == SubmissionStatus.draft) ...[
            Icon(Icons.drafts_outlined, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
