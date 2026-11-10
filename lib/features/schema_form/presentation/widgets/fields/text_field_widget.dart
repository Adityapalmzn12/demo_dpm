import 'package:flutter/material.dart';

import '../../../domain/entities/field_definition.dart';
import '../gform_question_card.dart';

class SchemaTextField extends StatefulWidget {
  const SchemaTextField({
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
  State<SchemaTextField> createState() => _SchemaTextFieldState();
}

class _SchemaTextFieldState extends State<SchemaTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant SchemaTextField oldWidget) {
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
        onChanged: widget.onChanged,
        decoration: const InputDecoration(
          hintText: 'Your answer',
        ),
      ),
    );
  }
}
