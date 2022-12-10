import 'package:flutter/material.dart';
import 'package:student_db/helpers/database_helper.dart';
import 'package:student_db/models/student_model.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key, this.student, required this.action})
      : super(key: key);
  final Student? student;
  final VoidCallback action;

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final formKey = GlobalKey<FormState>();
  final rollNoController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isCreateMode = widget.student == null;
    if (!isCreateMode)
      setState(() {
        nameController.text = widget.student!.name;
        ageController.text = widget.student!.age.toString();
      });
  }

  bool isCreateMode = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isCreateMode)
                  TextFormField(
                    controller: rollNoController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "enter a roll no";
                      }
                      return null;
                    },
                    decoration: buildDecoration('roll number'),
                  ),
                TextFormField(
                  controller: nameController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "enter a name";
                    }
                    return null;
                  },
                  decoration: buildDecoration('name'),
                ),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      "enter age";
                    }
                    try {
                      int.parse(val!);
                    } catch (e) {
                      return "enter a number";
                    }
                    return null;
                  },
                  decoration: buildDecoration('age'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        //final instance = DbHelper.instance;
                        // Database db = await this._initDb();
                        final DatabaseHelper instance = DatabaseHelper.instance;
                        final student = Student(
                          rollNo: isCreateMode
                              ? rollNoController.text.toLowerCase()
                              : widget.student!.rollNo,
                          name: nameController.text,
                          age: int.parse(ageController.text),
                        );
                        await isCreateMode
                            ? instance.insertStudent(student)
                            : instance.updateStudent(student);
                        setState(() {});
                        widget.action();
                        print("Data inserted/updated");
                        Navigator.pop(context);
                      }
                    },
                    child: Text('${isCreateMode ? "Add" : "Update"} Student'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildDecoration(hint) => InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      hintText: hint);
}
