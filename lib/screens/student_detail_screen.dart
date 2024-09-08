import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_crud_assignment/bloc/student_event.dart';
import 'package:student_api_crud_assignment/screens/student_form_screen.dart';

import '../bloc/student_bloc.dart';
import '../models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  StudentDetailScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${student.firstName} ${student.lastName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              BlocProvider.of<StudentBloc>(context).add(DeleteStudent(student.id));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: ${student.course}'),
            Text('Year: ${student.year}'),
            SwitchListTile(
              title: Text('Enrolled'),
              value: student.enrolled,
              onChanged: (bool value) {},
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentFormScreen(student: student),
                  ),
                );
              },
              child: Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
