import '../entities/field_definition.dart';
import '../entities/field_type.dart';
import '../entities/form_schema.dart';

/// Pure domain validator — no Flutter dependencies.
class SchemaValidator {
  const SchemaValidator();

  /// Practical email format check (optional fields may be empty).
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
  );

  Map<String, String> validate(
    FormSchema schema,
    Map<String, dynamic> values,
  ) {
    final errors = <String, String>{};

    for (final field in schema.fields) {
      final error = _validateField(field, values[field.id]);
      if (error != null) {
        errors[field.id] = error;
      }
    }

    _validateEmployedJoinDate(values, errors);
    return errors;
  }

  /// Employed staff may only use today or a past join date.
  /// Covers picking a future date first, then switching status to Employed.
  void _validateEmployedJoinDate(
    Map<String, dynamic> values,
    Map<String, String> errors,
  ) {
    final employment = values['employment']?.toString();
    if (employment != 'Employed') return;

    final raw = values['joinedOn']?.toString().trim() ?? '';
    if (raw.isEmpty) return;

    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return;

    final joinedDay = DateTime(parsed.year, parsed.month, parsed.day);
    final today = DateTime.now();
    final todayDay = DateTime(today.year, today.month, today.day);

    if (joinedDay.isAfter(todayDay)) {
      errors['joinedOn'] =
          'Employee must choose current or past date only';
    }
  }

  String? _validateField(FieldDefinition field, dynamic value) {
    switch (field.type) {
      case FieldType.text:
        return _validateText(field, value);
      case FieldType.number:
        return _validateNumber(field, value);
      case FieldType.dropdown:
        return _validateDropdown(field, value);
      case FieldType.date:
        return _validateDate(field, value);
      case FieldType.checkbox:
        return _validateCheckbox(field, value);
      case FieldType.email:
        return _validateEmail(field, value);
    }
  }

  String? _validateEmail(FieldDefinition field, dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) {
      if (field.required) return 'This question is required';
      return null;
    }
    if (!emailPattern.hasMatch(text)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateText(FieldDefinition field, dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (field.required && text.isEmpty) {
      return 'This question is required';
    }
    return null;
  }

  String? _validateNumber(FieldDefinition field, dynamic value) {
    final raw = value?.toString().trim() ?? '';
    if (raw.isEmpty) {
      if (field.required) return 'This question is required';
      return null;
    }

    final number = num.tryParse(raw);
    if (number == null) {
      return 'Enter a valid number';
    }
    if (field.min != null && number < field.min!) {
      return 'Must be at least ${field.min}';
    }
    if (field.max != null && number > field.max!) {
      return 'Must be at most ${field.max}';
    }
    return null;
  }

  String? _validateDropdown(FieldDefinition field, dynamic value) {
    final selected = value?.toString();
    if (selected == null || selected.isEmpty) {
      if (field.required) return 'This question is required';
      return null;
    }
    final options = field.options ?? const <String>[];
    if (options.isNotEmpty && !options.contains(selected)) {
      return 'Select a valid option';
    }
    return null;
  }

  String? _validateDate(FieldDefinition field, dynamic value) {
    final raw = value?.toString().trim() ?? '';
    if (raw.isEmpty) {
      if (field.required) return 'This question is required';
      return null;
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return 'Enter a valid date';
    }
    return null;
  }

  String? _validateCheckbox(FieldDefinition field, dynamic value) {
    final checked = value == true;
    if (field.required && !checked) {
      return 'This question is required';
    }
    return null;
  }
}
