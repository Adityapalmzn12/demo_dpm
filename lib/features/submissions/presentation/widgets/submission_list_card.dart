import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/submission.dart';
import '../../domain/entities/submission_status.dart';
import 'status_chip.dart';

class SubmissionListCard extends StatelessWidget {
  const SubmissionListCard({
    super.key,
    required this.submission,
    required this.onTap,
    this.trailing,
  });

  final Submission submission;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('MMM d, yyyy · h:mm a').format(submission.createdAt.toLocal());
    final isDraft = submission.status == SubmissionStatus.draft;

    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              if (isDraft) ...[
                const Icon(
                  Icons.drafts_outlined,
                  color: AppColors.draftAccent,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      submission.primaryPreview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dateLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StatusChip(status: submission.status),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
