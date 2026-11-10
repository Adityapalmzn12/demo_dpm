import 'package:flutter/material.dart';

import '../../../domain/entities/field_definition.dart';
import '../gform_question_card.dart';

class SchemaEmailField extends StatefulWidget {
  const SchemaEmailField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
    this.readOnly = false,
  });

  final FieldDefinition field;
  final String value;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final bool readOnly;

  @override
  State<SchemaEmailField> createState() => _SchemaEmailFieldState();
}

class _SchemaEmailFieldState extends State<SchemaEmailField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant SchemaEmailField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GformQuestionCard(
      label: widget.field.displayLabel,
      required: widget.field.required,
      errorText: widget.errorText,
      readOnly: widget.readOnly,
      child: TextField(
        controller: _controller,
        enabled: !widget.readOnly,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        onChanged: widget.onChanged,
        decoration: const InputDecoration(
          hintText: 'name@example.com',
        ),
      ),
    );
  }
}
