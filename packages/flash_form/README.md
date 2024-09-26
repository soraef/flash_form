# Flash Form Flutter Package

<div style="text-align: center;">
  <img src="https://github.com/soraef/flash_form/blob/main/docs/image/logo.webp" alt="FlashForm　Logo" style="width: 300px;">
</div>

FlashForm is a Flutter package that simplifies form creation by automatically generating form fields from your data model's structure. This eliminates the need to manually create widgets for each field, allowing you to build forms quickly and efficiently.

## Features

- **Automatic Form Generation**: Define your model's structure, and FlashForm will generate the corresponding form fields automatically.
- **Customizable Fields**: Easily configure validation rules, labels, decorators, input formats, and more for each field.
- **Nested Forms Support**: Create forms for complex, nested data models with ease.
- **List and Dynamic Fields Support**: Manage list-based fields and dynamically add or remove fields within your form.
- **Data Model Integration**: Convert form inputs directly to your data model and initialize forms from existing data.

## Demo

Check out the [live demo](https://flash-form-example.web.app) to see FlashForm in action.

## Installation

Add `flash_form` to your `pubspec.yaml` file:

```yaml
dependencies:
  flash_form: ^latest_version
```

Then run:

```bash
flutter pub get
```

## Getting Started

### 1. Define a `ModelSchema`

Create a `ModelSchema` for your data model. This schema will define the form fields and their behavior.

#### Example Data Model

Suppose you have a simple `Person` class:

```dart
class Person {
  String name;
  int age;

  Person({
    required this.name,
    required this.age,
  });
}
```

#### Create `PersonSchema`

Extend `ModelSchema` to create `PersonSchema` and define form fields:

```dart
class PersonSchema extends ModelSchema<Person> {
  PersonSchema() : super(parent: null);

  // Name field
  late final nameField = ValueSchema<String, String>(
    fieldFormat: TextFieldFormat(),
    decorators: [
      const DefaultValueDecorator(label: 'Name'),
    ],
    validators: [
      RequiredValidator(),
    ],
    value: null,
    parent: this,
  );

  // Age field
  late final ageField = ValueSchema<num, String>(
    fieldFormat: NumberFieldFormat(),
    decorators: [
      const DefaultValueDecorator(label: 'Age'),
    ],
    validators: [
      RequiredValidator(),
      RangeValidator(min: 0, max: 120),
    ],
    value: null,
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [
        nameField,
        ageField,
      ];

  // Convert between model and form
  @override
  void fromModel(Person model) { /* ... */ }

  @override
  Person toModel() { /* ... */ }
}
```

Note:
- **Field Definitions**: Each form field is defined using `ValueSchema`.
- **Field Formats**: Specify input types like `TextFieldFormat` and `NumberFieldFormat`.
- **Decorators**: Add labels and other UI decorations.
- **Validators**: Enforce validation rules such as `RequiredValidator` and `RangeValidator`.
- **Fields List**: The `fields` getter returns a list of fields to include in the form.

### 2. Use `FlashModelField` in Your Widget

Pass the `PersonSchema` instance to `FlashModelField` to render the form in your widget:

```dart
// Inside your widget's build method
FlashModelField(form: form),
```

Handle form submission and validation:

```dart
ElevatedButton(
  onPressed: () {
    if (form.validate()) {
      final person = form.toModel();
      // Use the 'person' object as needed
    }
  },
  child: const Text('Submit'),
),
```

## Advanced Usage

### Adding a Multi-Select Field

You can extend your data model and schema to include fields like a list of skills selected via checkboxes.

#### Update Data Model

```dart
class Person {
  String name;
  int age;
  List<String> skills;

  Person({
    required this.name,
    required this.age,
    required this.skills,
  });
}
```

#### Update `PersonSchema`

Add a `skillsField` to your schema:

```dart
late final skillsField = ValueSchema<List<String>, List<String>>(
  fieldFormat: MultiSelectFieldFormat.checkbox(
    options: ['Dart', 'Flutter', 'Java', 'Kotlin'],
    toDisplay: (value) => value,
  ),
  decorators: [
    const DefaultValueDecorator(label: 'Skills'),
  ],
  value: [],
  parent: this,
);

// Include 'skillsField' in the fields list
@override
List<FieldSchema> get fields => [
      nameField,
      ageField,
      skillsField,
    ];
```

### Adding a Dynamic List Field

Allow users to dynamically add or remove items in a list, such as hobbies.

#### Update Data Model

```dart
class Person {
  // ... existing fields ...
  List<String> hobbies;

  Person({
    // ... existing parameters ...
    required this.hobbies,
  });
}
```

#### Update `PersonSchema`

Add a `hobbiesField` to your schema:

```dart
late final hobbiesField = ListSchema<String, String>(
  children: [],
  decorators: [
    const DefaultListDecorator(label: 'Hobbies'),
  ],
  childFactory: (value, parent) {
    return ValueSchema<String, String>(
      fieldFormat: TextFieldFormat(),
      value: value,
      parent: parent,
    );
  },
  parent: this,
);

// Include 'hobbiesField' in the fields list
@override
List<FieldSchema> get fields => [
      nameField,
      ageField,
      skillsField,
      hobbiesField,
    ];
```

## Example Usage

Here's how you might integrate `PersonSchema` into your application:

```dart
class MyHomePage extends StatefulWidget {
  // ... constructor ...

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final form = PersonSchema();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FlashModelField(form: form),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if (form.validate()) {
                  final person = form.toModel();
                  // Use the 'person' object as needed
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Contributing

We welcome contributions! If you have ideas for new features or improvements, please open an issue or submit a pull request on our [GitHub repository](https://github.com/soraef/flash_form).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Thank you for using FlashForm! We hope it makes your form creation process faster and easier. If you have any feedback or need additional features, feel free to reach out.

---