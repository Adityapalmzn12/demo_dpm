import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class GformQuestionCard extends StatelessWidget {
  const GformQuestionCard({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.errorText,
    this.readOnly = false,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? errorText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  if (required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            child,
            if (hasError && !readOnly) ...[
              const SizedBox(height: 8),
              Text(
                errorText!,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
