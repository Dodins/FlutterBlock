import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_api_crud_assignment/bloc/student_bloc.dart';
import 'package:student_api_crud_assignment/bloc/student_event.dart';
import 'package:student_api_crud_assignment/models/student.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({Key? key, this.student}) : super(key: key);

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
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Last Name',
                initialValue: _lastName,
                onSaved: (value) => _lastName = value!,
              ),
              const SizedBox(height: 16),
              _buildCourseYearRow(),
              const SizedBox(height: 16),
              _buildSwitch(),
              const SizedBox(height: 32),
              widget.student == null
                  ? _buildSaveButton(context)
                  : _buildUpdateDeleteButtons(context),
            ],
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
        labelStyle: const TextStyle(fontSize: 18, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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

  Widget _buildCourseYearRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            label: 'Course',
            initialValue: _course,
            onSaved: (value) => _course = value!,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDropdown(),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _year,
      decoration: InputDecoration(
        labelText: 'Year',
        labelStyle: const TextStyle(fontSize: 18, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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
                child: Text(year, style: const TextStyle(fontSize: 16)),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Enrolled?',
            style: TextStyle(fontSize: 18),
          ),
          Switch(
            value: _enrolled,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
            onChanged: (bool value) {
              setState(() {
                _enrolled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blueAccent,
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
              const SnackBar(content: Text('Student Added Successfully!')),
            );
            Navigator.pop(context);
          }
        },
        child: const Text(
          'Add Student',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildUpdateDeleteButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.blueAccent,
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
                const SnackBar(content: Text('Student Updated Successfully!')),
              );
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Update',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.blueAccent,
          ),
          onPressed: () {
            BlocProvider.of<StudentBloc>(context)
                .add(DeleteStudent(widget.student!.id));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Student Deleted Successfully!')),
            );
            Navigator.pop(context);
          },
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
