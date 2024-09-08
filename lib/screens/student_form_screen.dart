import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_crud_assignment/bloc/student_bloc.dart';
import 'package:student_api_crud_assignment/bloc/student_event.dart';
import 'package:student_api_crud_assignment/models/student.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  StudentFormScreen({this.student});

  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _course;
  late String _year;
  bool _enrolled = false;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _firstName = widget.student!.firstName;
      _lastName = widget.student!.lastName;
      _course = widget.student!.course;
      _year = widget.student!.year;
      _enrolled = widget.student!.enrolled;
    } else {
      _firstName = '';
      _lastName = '';
      _course = '';
      _year = 'First Year';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _firstName = value!;
                },
              ),
              TextFormField(
                initialValue: _lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lastName = value!;
                },
              ),
              TextFormField(
                initialValue: _course,
                decoration: InputDecoration(labelText: 'Course'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course';
                  }
                  return null;
                },
                onSaved: (value) {
                  _course = value!;
                },
              ),
              DropdownButtonFormField<String>(
                value: _year,
                decoration: InputDecoration(labelText: 'Year'),
                items: ['First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year']
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text(year),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _year = value!;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Enrolled'),
                value: _enrolled,
                onChanged: (bool value) {
                  setState(() {
                    _enrolled = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final studentData = {
                      'firstName': _firstName,
                      'lastName': _lastName,
                      'course': _course,
                      'year': _year,
                      'enrolled': _enrolled,
                    };

                    if (widget.student == null) {
                      BlocProvider.of<StudentBloc>(context).add(AddStudent(studentData));
                    } else {
                      BlocProvider.of<StudentBloc>(context).add(UpdateStudent(widget.student!.id, studentData));
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
