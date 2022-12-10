import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_db/helpers/database_helper.dart';
import 'package:student_db/models/student_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_db/screens/add_student.dart';

class StudentTile extends StatelessWidget {
  StudentTile({Key? key, required this.student, required this.action})
      : super(key: key);
  final Student student;
  //final DbHelper dbHelper = DbHelper.instance;
  final instance = DatabaseHelper.instance;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              await showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                context: context,
                builder: (context) {
                  return AddStudent(
                    student: student,
                    action: action,
                  );
                },
              );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.update,
            label: 'update',
          ),
          SlidableAction(
            onPressed: (c) async {
              await instance.deleteStudent(student.rollNo);
              //DbHelper.instance.deleteStudent(student.rollNo);
              action();
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'delete',
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  'Swipe to update or delete',
                  style: TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ),
              Text(student.rollNo),
            ],
          ),
          subtitle: Text("${student.name}\nage: ${student.age}"),
          contentPadding: const EdgeInsets.all(25.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
