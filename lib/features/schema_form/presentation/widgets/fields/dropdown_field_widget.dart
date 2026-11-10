import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/field_definition.dart';
import '../gform_question_card.dart';

class SchemaDropdownField extends StatelessWidget {
  const SchemaDropdownField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
    this.readOnly = false,
  });

  final FieldDefinition field;
  final String? value;
  final String? errorText;
  final ValueChanged<String?> onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final options = field.options ?? const <String>[];

    return GformQuestionCard(
      label: field.displayLabel,
      required: field.required,
      errorText: errorText,
      readOnly: readOnly,
      child: DropdownButtonFormField<String>(
        initialValue: value != null && options.contains(value) ? value : null,
        isExpanded: true,
        hint: const Text('Choose'),
        items: options
            .map(
              (option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              ),
            )
            .toList(),
        onChanged: readOnly ? null : onChanged,
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}
