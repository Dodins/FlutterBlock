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
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'First Name',
                  initialValue: _firstName,
                  onSaved: (value) => _firstName = value!,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Last Name',
                  initialValue: _lastName,
                  onSaved: (value) => _lastName = value!,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Course',
                  initialValue: _course,
                  onSaved: (value) => _course = value!,
                ),
                SizedBox(height: 16),
                _buildDropdown(),
                SizedBox(height: 16),
                _buildSwitch(),
                SizedBox(height: 30),
                widget.student == null
                    ? _buildSaveButton(context)
                    : _buildUpdateDeleteButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _year,
      decoration: InputDecoration(
        labelText: 'Year',
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
      ),
      items: [
        'First Year',
        'Second Year',
        'Third Year',
        'Fourth Year',
        'Fifth Year'
      ]
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
    );
  }

  Widget _buildSwitch() {
    return SwitchListTile(
      title: Text(
        'Enrolled',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      value: _enrolled,
      activeColor: Colors.green,
      inactiveThumbColor: Colors.grey,
      onChanged: (bool value) {
        setState(() {
          _enrolled = value;
        });
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
            BlocProvider.of<StudentBloc>(context).add(AddStudent(studentData));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Student Added Successfully!')),
            );
            Navigator.pop(context);
          }
        },
        child: Text('Save'),
      ),
    );
  }

  Widget _buildUpdateDeleteButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
              BlocProvider.of<StudentBloc>(context)
                  .add(UpdateStudent(widget.student!.id, studentData));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Student Updated Successfully!')),
              );
              Navigator.pop(context);
            }
          },
          child: Text('Update'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            BlocProvider.of<StudentBloc>(context)
                .add(DeleteStudent(widget.student!.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Student Deleted Successfully!')),
            );
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
