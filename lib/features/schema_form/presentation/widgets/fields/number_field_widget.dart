import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/entities/field_definition.dart';
import '../gform_question_card.dart';

class SchemaNumberField extends StatefulWidget {
  const SchemaNumberField({
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
  State<SchemaNumberField> createState() => _SchemaNumberFieldState();
}

class _SchemaNumberFieldState extends State<SchemaNumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant SchemaNumberField oldWidget) {
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
        ],
        onChanged: widget.onChanged,
        decoration: const InputDecoration(
          hintText: 'Your answer',
        ),
      ),
    );
  }
}
