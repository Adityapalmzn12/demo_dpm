import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/field_definition.dart';
import '../gform_question_card.dart';

class SchemaDateField extends StatelessWidget {
  const SchemaDateField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
    this.readOnly = false,
    this.lastDate,
  });

  final FieldDefinition field;
  final String? value;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final bool readOnly;
  final DateTime? lastDate;

  Future<void> _pickDate(BuildContext context) async {
    if (readOnly) return;
    final today = DateTime.now();
    final maxDate = lastDate ?? DateTime(2100);
    final parsed = value != null ? DateTime.tryParse(value!) : null;
    var initial = parsed ?? today;
    if (initial.isAfter(maxDate)) {
      initial = maxDate;
    }
    final firstDate = DateTime(1970);
    if (initial.isBefore(firstDate)) {
      initial = firstDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: maxDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.purple,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onChanged(picked.toIso8601String().split('T').first);
    }
  }

  @override
  Widget build(BuildContext context) {
    String display = 'Month, day, year';
    if (value != null && value!.isNotEmpty) {
      final parsed = DateTime.tryParse(value!);
      if (parsed != null) {
        display = DateFormat.yMMMMd().format(parsed);
      } else {
        display = value!;
      }
    }

    return GformQuestionCard(
      label: field.displayLabel,
      required: field.required,
      errorText: errorText,
      readOnly: readOnly,
      child: InkWell(
        onTap: () => _pickDate(context),
        child: InputDecorator(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_today_outlined, size: 20),
          ),
          child: Text(
            display,
            style: TextStyle(
              color: value == null || value!.isEmpty
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
