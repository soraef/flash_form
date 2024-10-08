import 'package:flutter/widgets.dart';
import 'package:person_form/models.dart';
import 'package:flash_form/flash_form.dart';

class PersonSchema extends ModelSchema<Person> {
  PersonSchema() : super(parent: null);

  late final nameField = ValueSchema(
    fieldFormat: TextFieldFormat(),
    decorators: (_) => [
      const DefaultValueDecorator(label: 'Name'),
    ],
    validators: [
      RequiredValidator(),
    ],
    value: null,
    parent: this,
  );

  late final ageField = ValueSchema(
    fieldFormat: NumberFieldFormat(),
    decorators: (_) => [
      const DefaultValueDecorator(label: 'Age'),
    ],
    validators: [
      RequiredValidator(),
      RangeValidator(min: 0, max: 120),
    ],
    value: 20,
    parent: this,
  );

  // multi seelect field format
  late final skills = ValueSchema(
    fieldFormat: MultiSelectFieldFormat.checkbox(
      options: ['Dart', 'Flutter', 'Java', 'Kotlin'],
      toDisplay: (value) => value,
    ),
    decorators: (_) => [
      const DefaultValueDecorator(label: 'Skills'),
    ],
    parent: this,
  );

  late final hobbyField = ListSchema<String, String>(
    children: [],
    decorators: (_) => [
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

  late final childrenField = ListSchema<Child, Child>(
    children: [
      ChildForm(),
    ],
    decorators: (_) => [
      const DefaultListDecorator(label: 'Children'),
    ],
    childFactory: (value, parent) {
      return ChildForm(
        parent: parent,
      );
    },
    parent: this,
  );

  late final roleField = TypeSchema<Role, Role, Type>(
    typeFactory: (Role value) => value.runtimeType,
    typeOptions: [
      Student,
      Employee,
    ],
    decorators: (_) => [
      const DefaultTypeDecorator(label: 'Role'),
    ],
    factory: (Type? value, TypeSchema<dynamic, dynamic, dynamic> parent) {
      if (value == Student) {
        return StudentForm(
          parent: parent,
        );
      } else if (value == Employee) {
        return EmployeeForm(
          parent: parent,
        );
      } else {
        return StudentForm(
          parent: parent,
        );
      }
    },
    type: null,
    parent: this,
    toDisplay: (BuildContext context, Type value) {
      if (value == Student) {
        return 'Student';
      } else if (value == Employee) {
        return 'Employee';
      }
      return '';
    },
  );

  @override
  List<FieldSchema> get fields => [
        nameField,
        ageField,
        hobbyField,
        skills,
        childrenField,
        roleField,
      ];

  @override
  void fromModel(Person model) {
    nameField.updateValue(model.name);
    ageField.updateValue(model.age);
    hobbyField.updateValue(model.hobby);
    childrenField.updateValue(model.children);
    roleField.updateValue(model.role);
  }

  @override
  Person toModel() {
    return Person(
      name: nameField.value ?? 'No Name',
      age: ageField.value?.toInt() ?? 0,
      skills: skills.value ?? [],
      hobby: hobbyField.value ?? [],
      children: childrenField.value ?? [],
      role: roleField.value!,
    );
  }
}

class ChildForm extends ModelSchema<Child> {
  ChildForm({super.parent})
      : super(
          decorators: (_) => [
            CardDecorator(),
          ],
          fieldFormat: const ModelFieldFormat(),
        );

  late final nameField = ValueSchema<String, String>(
    fieldFormat: TextFieldFormat(),
    decorators: (_) => [
      const DefaultValueDecorator(label: 'Name'),
    ],
    value: '',
    parent: this,
  );

  late final ageField = ValueSchema<num, String>(
    fieldFormat: NumberFieldFormat(),
    decorators: (_) => [
      const DefaultValueDecorator(label: 'Age'),
    ],
    value: 12,
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [nameField, ageField];

  @override
  void fromModel(Child model) {
    nameField.updateValue(model.name);
    ageField.updateValue(model.age);
  }

  @override
  Child toModel() {
    return Child(
      name: nameField.value ?? 'No Name',
      age: ageField.value?.toInt() ?? 0,
    );
  }
}

class StudentForm extends ModelSchema<Student> {
  StudentForm({
    super.parent,
  }) : super(
          fieldFormat: const ModelFieldFormat(),
        );

  late final schoolField = ValueSchema<String, String>(
    fieldFormat: TextFieldFormat(),
    decorators: (_) => [
      const DefaultValueDecorator(label: 'School'),
    ],
    value: null,
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [schoolField];

  @override
  void fromModel(Student model) {
    schoolField.updateValue(model.school);
  }

  @override
  Student toModel() {
    return Student(
      school: schoolField.value ?? 'No School',
    );
  }
}

class EmployeeForm extends ModelSchema<Employee> {
  EmployeeForm({
    super.parent,
  }) : super(
          fieldFormat: const ModelFieldFormat(),
        );

  late final companyField = ValueSchema<String, String>(
    parent: this,
    fieldFormat: TextFieldFormat(),
    decorators: (_) => [
      const DefaultValueDecorator(label: 'Company'),
    ],
    value: null,
  );

  @override
  List<FieldSchema> get fields => [companyField];

  @override
  void fromModel(Employee model) {
    companyField.updateValue(model.company);
  }

  @override
  Employee toModel() {
    return Employee(
      company: companyField.value ?? 'No Company',
    );
  }
}
