import 'package:flutter/material.dart';

import '../../domain/entities/form_schema.dart';
import 'field_widget_factory.dart';

class SchemaForm extends StatelessWidget {
  const SchemaForm({
    super.key,
    required this.schema,
    required this.values,
    required this.errors,
    required this.onChanged,
    this.readOnly = false,
    this.factory = const FieldWidgetFactory(),
  });

  final FormSchema schema;
  final Map<String, dynamic> values;
  final Map<String, String> errors;
  final FieldValueChanged onChanged;
  final bool readOnly;
  final FieldWidgetFactory factory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final field in schema.fields) ...[
          factory.build(
            field: field,
            value: values[field.id],
            errorText: errors[field.id],
            onChanged: onChanged,
            formValues: values,
            readOnly: readOnly,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
