import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/field_definition.dart';
import '../gform_question_card.dart';

class SchemaCheckboxField extends StatelessWidget {
  const SchemaCheckboxField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
    this.readOnly = false,
  });

  final FieldDefinition field;
  final bool value;
  final String? errorText;
  final ValueChanged<bool> onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return GformQuestionCard(
      label: field.displayLabel,
      required: field.required,
      errorText: errorText,
      readOnly: readOnly,
      child: CheckboxListTile(
        value: value,
        onChanged: readOnly
            ? null
            : (checked) => onChanged(checked ?? false),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        activeColor: AppColors.purple,
        title: const Text(
          'Yes',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        dense: true,
      ),
    );
  }
}
