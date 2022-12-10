class Student {
  String rollNo;
  String name;
  int age;

  Student({required this.rollNo, required this.name, required this.age});

  Map<String, dynamic> toMap() => {
        "rollNo": rollNo,
        "name": name.toLowerCase(),
        "age": age,
      };

  static Student fromMap(Map<String, dynamic> json) => Student(
        rollNo: json["rollNo"],
        name: json["name"],
        age: json["age"],
      );
}
