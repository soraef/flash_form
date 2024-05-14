import 'package:person_form/models.dart';
import 'package:quick_form/quick_form.dart';

class PersonForm extends QuickForm<Person> {
  PersonForm() : super(label: 'Person Form');

  final nameField = ValueField<String, String>(
    label: 'Name',
    fieldFormat: TextFieldFormat(),
    value: null,
  );

  final ageField = ValueField<int, String>(
    label: 'Age',
    fieldFormat: NumberFieldFormat(),
    value: 20,
  );

  final hobbyField = ListField<String, String>(
    label: 'Hobby',
    children: [],
    childFactory: (value) {
      return ValueField<String, String>(
        label: 'Hobby',
        fieldFormat: TextFieldFormat(),
        value: value,
      );
    },
  );

  final childrenField = ListField<Child, Child>(
    label: 'Children',
    children: [],
    childFactory: (value) {
      return ChildForm();
    },
  );

  final roleField = TypeField<Role, Role, Type>(
    label: 'Role',
    fields: {
      Student: StudentForm(),
      Employee: EmployeeForm(),
    },
    type: null,
    typeFactory: (Role value) => value.runtimeType,
  );

  @override
  List<QuickField> get fields => [
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

class ChildForm extends QuickForm<Child> {
  ChildForm()
      : super(
          label: 'Child Form',
          fieldFormat: const ModelFieldFormat(),
        );

  final nameField = ValueField<String, String>(
    label: 'Name',
    fieldFormat: TextFieldFormat(),
    value: '',
  );

  final ageField = ValueField<int, String>(
    label: 'Age',
    fieldFormat: NumberFieldFormat(),
    value: 12,
  );

  @override
  List<QuickField> get fields => [nameField, ageField];

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

class StudentForm extends QuickForm<Student> {
  StudentForm()
      : super(
          label: 'Student Form',
          fieldFormat: const ModelFieldFormat(),
        );

  final schoolField = ValueField<String, String>(
    label: 'School',
    fieldFormat: TextFieldFormat(),
    value: null,
  );

  @override
  List<QuickField> get fields => [schoolField];

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

class EmployeeForm extends QuickForm<Employee> {
  EmployeeForm()
      : super(
          label: 'Employee Form',
          fieldFormat: const ModelFieldFormat(),
        );

  final companyField = ValueField<String, String>(
    label: 'Company',
    fieldFormat: TextFieldFormat(),
    value: null,
  );

  @override
  List<QuickField> get fields => [companyField];

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
