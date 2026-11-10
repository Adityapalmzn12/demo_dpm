import 'package:equatable/equatable.dart';

import 'field_type.dart';

class FieldDefinition extends Equatable {
  const FieldDefinition({
    required this.id,
    required this.type,
    this.label,
    this.required = false,
    this.min,
    this.max,
    this.options,
  });

  final String id;
  final FieldType type;
  final String? label;
  final bool required;
  final num? min;
  final num? max;
  final List<String>? options;

  String get displayLabel {
    if (label != null && label!.trim().isNotEmpty) {
      return label!;
    }
    if (id.isEmpty) return id;
    final buffer = StringBuffer(id[0].toUpperCase());
    for (var i = 1; i < id.length; i++) {
      final ch = id[i];
      if (ch == '_' || ch == '-') {
        buffer.write(' ');
        continue;
      }
      if (ch.toUpperCase() == ch && ch.toLowerCase() != ch) {
        buffer.write(' ');
      }
      buffer.write(ch);
    }
    return buffer.toString();
  }

  factory FieldDefinition.fromJson(Map<String, dynamic> json) {
    return FieldDefinition(
      id: json['id'] as String,
      type: FieldType.fromString(json['type'] as String),
      label: json['label'] as String?,
      required: json['required'] as bool? ?? false,
      min: json['min'] as num?,
      max: json['max'] as num?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        if (label != null) 'label': label,
        'required': required,
        if (min != null) 'min': min,
        if (max != null) 'max': max,
        if (options != null) 'options': options,
      };

  @override
  List<Object?> get props => [id, type, label, required, min, max, options];
}
