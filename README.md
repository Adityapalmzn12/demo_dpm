# Schema-Driven Form App (`demo_pfm`)

Flutter app that renders configurable forms from JSON schema, stores submissions locally, and manages soft-delete/trash — built with **Clean Architecture**, **Redux**, and a **Google Forms–like UI**.

## Run

```bash
cd demo_pfm
flutter pub get
flutter run
```

## Test

```bash
flutter test
flutter analyze
```

## Architecture

```text
Presentation  →  Redux (actions / thunks / reducers)  →  Use Cases  →  Repository  →  Hive
```

| Layer | Responsibility |
|-------|----------------|
| **Domain** | Entities, repository interfaces, `SchemaValidator`, use cases. No Flutter/Hive/Redux. |
| **Data** | Hive datasource, DTOs, `SubmissionRepositoryImpl`, asset `SchemaLoader`. |
| **Presentation** | Google Forms–style pages/widgets + Redux store connectors. |
| **Redux** | Single `AppState` shared by Responses / Form / Trash. |

### Feature folders

- `lib/features/schema_form/` — pluggable schema engine (field factory + validators)
- `lib/features/submissions/` — submissions lifecycle (list, create, trash, restore, delete)

### Redux flow

1. UI dispatches an action or thunk
2. Thunk calls a domain use case (Hive only via repository)
3. Reducer updates `AppState`
4. `StoreConnector` rebuilds List / Trash / Detail from the same store

## Screens

1. **Responses** — search/filter, status, detail, move to trash
2. **Form** — schema-driven inputs, inline validation, submit
3. **Trash** — restore or permanently delete (with confirmation)

## Starter schema

`assets/schemas/employee_v1.json` drives the Form tab. Fields are generated from schema — not hardcoded in the page.

Supported field types: `text`, `number`, `dropdown`, `date`, `checkbox`.

## How to add a new field type

1. Add a value to `FieldType` and parse it in `fromString`
2. Extend `SchemaValidator` with type-specific rules
3. Create a field widget under `schema_form/presentation/widgets/fields/`
4. Register it in `FieldWidgetFactory`
5. Screens stay unchanged

## How to swap persistence later

Implement `SubmissionRepository` (e.g. API or SQLite). Wire it in `injection.dart`. Thunks and UI stay the same.

## UI notes (Google Forms–inspired)

- Soft lavender-gray canvas (`#F0EBF8`)
- Purple accent (`#673AB7`) header strip and primary button
- One question per white card
- Required marker `*`
- Inline errors under each question
# demo_dpm
