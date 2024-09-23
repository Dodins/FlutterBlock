import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_crud_assignment/bloc/student_bloc.dart';
import 'package:student_api_crud_assignment/bloc/student_event.dart';
import 'package:student_api_crud_assignment/bloc/student_state.dart';
import 'package:student_api_crud_assignment/screens/student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentBloc>(context).add(LoadStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StudentLoaded) {
            final students = state.students;
            // Check if students list is empty
            if (students.isEmpty) {
              return const Center(
                child: Text(
                  'No Data Available',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              );
            }
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the form screen with the selected student data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentFormScreen(
                            student: student,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${student.firstName} ${student.lastName}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Course: ${student.course}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Year: ${student.year}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              student.enrolled
                                  ? 'Enrolled: Yes'
                                  : 'Enrolled: No',
                              style: TextStyle(
                                fontSize: 16,
                                color: student.enrolled
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12),
                            Center(
                              child: Text(
                                'Tap to Edit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is StudentError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('No data'));
        },
      ),
    );
  }
}
