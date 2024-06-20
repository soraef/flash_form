import 'package:person_form/models.dart';
import 'package:flash_form/flash_form.dart';

class PersonForm extends ModelSchema<Person> {
  PersonForm() : super(label: 'Person Form');

  final nameField = ValueSchema<String, String>(
    label: 'Name',
    fieldFormat: TextFieldFormat(),
    value: null,
  );

  final ageField = ValueSchema<int, String>(
    label: 'Age',
    fieldFormat: NumberFieldFormat(),
    value: 20,
  );

  final hobbyField = ListSchema<String, String>(
    label: 'Hobby',
    children: [],
    childFactory: (value) {
      return ValueSchema<String, String>(
        label: 'Hobby',
        fieldFormat: TextFieldFormat(),
        value: value,
      );
    },
  );

  final childrenField = ListSchema<Child, Child>(
    label: 'Children',
    children: [],
    childFactory: (value) {
      return ChildForm();
    },
  );

  final roleField = TypeSchema<Role, Role, Type>(
    label: 'Role',
    fields: {
      Student: () => StudentForm(),
      Employee: () => EmployeeForm(),
    },
    fieldType: null,
    typeFactory: (Role value) => value.runtimeType,
  );

  @override
  List<FieldSchema> get fields => [
        nameField,
        ageField,
        hobbyField,
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
      age: ageField.value ?? 0,
      hobby: hobbyField.value ?? [],
      children: childrenField.value ?? [],
      role: roleField.value!,
    );
  }
}

class ChildForm extends ModelSchema<Child> {
  ChildForm()
      : super(
          label: 'Child Form',
          fieldFormat: const ModelFieldFormat(),
        );

  final nameField = ValueSchema<String, String>(
    label: 'Name',
    fieldFormat: TextFieldFormat(),
    value: '',
  );

  final ageField = ValueSchema<int, String>(
    label: 'Age',
    fieldFormat: NumberFieldFormat(),
    value: 12,
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
      age: ageField.value ?? 0,
    );
  }
}

class StudentForm extends ModelSchema<Student> {
  StudentForm()
      : super(
          label: 'Student Form',
          fieldFormat: const ModelFieldFormat(),
        );

  final schoolField = ValueSchema<String, String>(
    label: 'School',
    fieldFormat: TextFieldFormat(),
    value: null,
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
  EmployeeForm()
      : super(
          label: 'Employee Form',
          fieldFormat: const ModelFieldFormat(),
        );

  final companyField = ValueSchema<String, String>(
    label: 'Company',
    fieldFormat: TextFieldFormat(),
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
