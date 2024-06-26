class Person {
  String name;
  int age;
  List<String> skills;
  List<String> hobby;
  List<Child> children;
  Role role;

  Person({
    required this.name,
    required this.age,
    required this.hobby,
    required this.skills,
    required this.children,
    required this.role,
  });
}

class Child {
  String name;
  int age;

  Child({
    required this.name,
    required this.age,
  });
}

abstract class Role {}

class Student extends Role {
  String school;

  Student({required this.school});
}

class Employee extends Role {
  String company;

  Employee({required this.company});
}
