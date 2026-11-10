import 'package:flutter/material.dart';

import '../../domain/entities/field_definition.dart';
import '../../domain/entities/field_type.dart';
import 'fields/checkbox_field_widget.dart';
import 'fields/date_field_widget.dart';
import 'fields/dropdown_field_widget.dart';
import 'fields/email_field_widget.dart';
import 'fields/number_field_widget.dart';
import 'fields/text_field_widget.dart';

typedef FieldValueChanged = void Function(String fieldId, dynamic value);

class FieldWidgetFactory {
  const FieldWidgetFactory();

  Widget build({
    required FieldDefinition field,
    required dynamic value,
    required String? errorText,
    required FieldValueChanged onChanged,
    required Map<String, dynamic> formValues,
    bool readOnly = false,
  }) {
    switch (field.type) {
      case FieldType.text:
        return SchemaTextField(
          field: field,
          value: value?.toString() ?? '',
          errorText: errorText,
          onChanged: (v) => onChanged(field.id, v),
          readOnly: readOnly,
        );
      case FieldType.number:
        return SchemaNumberField(
          field: field,
          value: value?.toString() ?? '',
          errorText: errorText,
          onChanged: (v) => onChanged(field.id, v),
          readOnly: readOnly,
        );
      case FieldType.dropdown:
        return SchemaDropdownField(
          field: field,
          value: value?.toString(),
          errorText: errorText,
          onChanged: (v) => onChanged(field.id, v),
          readOnly: readOnly,
        );
      case FieldType.date:
        return SchemaDateField(
          field: field,
          value: value?.toString(),
          errorText: errorText,
          onChanged: (v) => onChanged(field.id, v),
          readOnly: readOnly,
          lastDate: _joinedOnLastDate(field, formValues),
        );
      case FieldType.checkbox:
        return SchemaCheckboxField(
          field: field,
          value: value == true,
          errorText: errorText,
          onChanged: (v) => onChanged(field.id, v),
          readOnly: readOnly,
        );
      case FieldType.email:
        return SchemaEmailField(
          field: field,
          value: value?.toString() ?? '',
          errorText: errorText,
          onChanged: (v) => onChanged(field.id, v),
          readOnly: readOnly,
        );
    }
  }

  DateTime? _joinedOnLastDate(
    FieldDefinition field,
    Map<String, dynamic> formValues,
  ) {
    if (field.id != 'joinedOn') return null;
    if (formValues['employment']?.toString() == 'Employed') {
      return DateTime.now();
    }
    return null;
  }
}
