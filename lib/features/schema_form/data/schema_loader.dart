import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/entities/form_schema.dart';

class SchemaLoader {
  const SchemaLoader({
    this.assetPath = 'assets/schemas/employee_v1.json',
  });

  final String assetPath;

  Future<FormSchema> load() async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return FormSchema.fromJson(json);
  }
}
