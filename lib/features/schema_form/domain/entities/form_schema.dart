import 'package:equatable/equatable.dart';

import 'field_definition.dart';

class FormSchema extends Equatable {
  const FormSchema({
    required this.formId,
    required this.version,
    required this.fields,
    this.title,
    this.description,
  });

  final String formId;
  final int version;
  final List<FieldDefinition> fields;
  final String? title;
  final String? description;

  String get displayTitle =>
      (title != null && title!.trim().isNotEmpty) ? title! : formId;

  String get displayDescription =>
      description ?? 'Fill out the form and submit your response.';

  factory FormSchema.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'] as List<dynamic>? ?? const [];
    return FormSchema(
      formId: json['formId'] as String,
      version: (json['version'] as num?)?.toInt() ?? 1,
      title: json['title'] as String?,
      description: json['description'] as String?,
      fields: rawFields
          .map((e) => FieldDefinition.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'formId': formId,
        'version': version,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        'fields': fields.map((f) => f.toJson()).toList(),
      };

  @override
  List<Object?> get props => [formId, version, fields, title, description];
}
