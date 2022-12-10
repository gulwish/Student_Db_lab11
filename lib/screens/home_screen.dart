import 'package:flutter/material.dart';
import 'package:student_db/helpers/database_helper.dart';
import 'package:student_db/models/student_model.dart';
import 'package:student_db/screens/add_student.dart';
import 'package:student_db/screens/student_builder.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Student> students = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 11'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
              ? const Center(child: Text('No records available.'))
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) => StudentTile(
                    student: students[index],
                    action: () {
                      setState(
                        () {
                          loadStudents();
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            context: context,
            builder: (context) {
              return AddStudent(action: () {
                setState(() {
                  loadStudents();
                });
              });
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  toggleIsLoading() => setState(() {
        isLoading = !isLoading;
      });

  void loadStudents() async {
    toggleIsLoading();
    //final instance = DbHelper.instance;
    final  instance =  await  DatabaseHelper.instance ;


    final stds = await instance.getStudentList();
    //getAllStudents();
    if (students.length != stds.length) {
      setState(() {
        students = stds;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    toggleIsLoading();
  }
}
