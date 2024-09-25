import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_crud_assignment/bloc/student_bloc.dart';
import 'package:student_api_crud_assignment/bloc/student_event.dart';
import 'package:student_api_crud_assignment/bloc/student_state.dart';
import 'package:student_api_crud_assignment/screens/student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

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
        title: const Text('Student List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentLoaded) {
            final students = state.students;

            if (students.isEmpty) {
              return const Center(
                child: Text(
                  'No Students Found',
                  style: TextStyle(fontSize: 22, color: Colors.grey),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentFormScreen(student: student),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${student.firstName} ${student.lastName}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Course: ${student.course}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Year: ${student.year}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            student.enrolled
                                ? 'Status: Enrolled'
                                : 'Status: Not Enrolled',
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  student.enrolled ? Colors.green : Colors.red,
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StudentFormScreen(student: student),
                                  ),
                                );
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is StudentError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No data available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
