enum FieldType {
  text,
  number,
  dropdown,
  date,
  checkbox,
  email;

  static FieldType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'text':
        return FieldType.text;
      case 'number':
        return FieldType.number;
      case 'dropdown':
        return FieldType.dropdown;
      case 'date':
        return FieldType.date;
      case 'checkbox':
        return FieldType.checkbox;
      case 'email':
        return FieldType.email;
      default:
        throw ArgumentError('Unsupported field type: $value');
    }
  }
}
