import 'package:demo_pfm/features/schema_form/domain/entities/field_definition.dart';
import 'package:demo_pfm/features/schema_form/domain/entities/field_type.dart';
import 'package:demo_pfm/features/schema_form/domain/entities/form_schema.dart';
import 'package:demo_pfm/features/schema_form/domain/services/schema_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validator = SchemaValidator();

  final schema = FormSchema(
    formId: 'employee',
    version: 1,
    fields: const [
      FieldDefinition(id: 'name', type: FieldType.text, required: true),
      FieldDefinition(id: 'emailId', type: FieldType.email, required: false),
      FieldDefinition(id: 'age', type: FieldType.number, min: 18),
      FieldDefinition(
        id: 'employment',
        type: FieldType.dropdown,
        options: ['Employed', 'Student'],
      ),
      FieldDefinition(id: 'joinedOn', type: FieldType.date),
      FieldDefinition(
        id: 'agreeTerms',
        type: FieldType.checkbox,
        required: true,
      ),
    ],
  );

  test('flags required text and checkbox', () {
    final errors = validator.validate(schema, {
      'name': '',
      'agreeTerms': false,
    });

    expect(errors['name'], isNotNull);
    expect(errors['agreeTerms'], isNotNull);
  });

  test('flags age below minimum', () {
    final errors = validator.validate(schema, {
      'name': 'Ada',
      'age': '16',
      'agreeTerms': true,
    });

    expect(errors['age'], contains('18'));
  });

  test('flags invalid dropdown option', () {
    final errors = validator.validate(schema, {
      'name': 'Ada',
      'employment': 'Contractor',
      'agreeTerms': true,
    });

    expect(errors['employment'], isNotNull);
  });

  test('accepts valid payload', () {
    final errors = validator.validate(schema, {
      'name': 'Ada Lovelace',
      'emailId': 'ada@example.com',
      'age': '30',
      'employment': 'Employed',
      'joinedOn': '2020-01-15',
      'agreeTerms': true,
    });

    expect(errors, isEmpty);
  });

  test('allows empty optional email', () {
    final errors = validator.validate(schema, {
      'name': 'Ada',
      'emailId': '',
      'agreeTerms': true,
    });

    expect(errors['emailId'], isNull);
  });

  test('rejects invalid email format with regexp', () {
    final errors = validator.validate(schema, {
      'name': 'Ada',
      'emailId': 'not-an-email',
      'agreeTerms': true,
    });

    expect(errors['emailId'], isNotNull);
  });

  test('rejects future joinedOn when Employed', () {
    final future = DateTime.now().add(const Duration(days: 10));
    final futureIso =
        '${future.year.toString().padLeft(4, '0')}-${future.month.toString().padLeft(2, '0')}-${future.day.toString().padLeft(2, '0')}';

    final errors = validator.validate(schema, {
      'name': 'Ada',
      'employment': 'Employed',
      'joinedOn': futureIso,
      'agreeTerms': true,
    });

    expect(
      errors['joinedOn'],
      'Employee must choose current or past date only',
    );
  });

  test('future joinedOn becomes invalid after switching to Employed', () {
    final future = DateTime.now().add(const Duration(days: 5));
    final futureIso =
        '${future.year.toString().padLeft(4, '0')}-${future.month.toString().padLeft(2, '0')}-${future.day.toString().padLeft(2, '0')}';

    // Date chosen while Student is fine.
    final asStudent = validator.validate(schema, {
      'name': 'Ada',
      'employment': 'Student',
      'joinedOn': futureIso,
      'agreeTerms': true,
    });
    expect(asStudent['joinedOn'], isNull);

    // Changing employment to Employed must block submit.
    final asEmployed = validator.validate(schema, {
      'name': 'Ada',
      'employment': 'Employed',
      'joinedOn': futureIso,
      'agreeTerms': true,
    });
    expect(
      asEmployed['joinedOn'],
      'Employee must choose current or past date only',
    );
  });

  test('allows today joinedOn when Employed', () {
    final today = DateTime.now();
    final todayIso =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final errors = validator.validate(schema, {
      'name': 'Ada',
      'employment': 'Employed',
      'joinedOn': todayIso,
      'agreeTerms': true,
    });

    expect(errors['joinedOn'], isNull);
  });
}
