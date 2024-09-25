import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:student_api_crud_assignment/bloc/student_event.dart';

import 'dart:convert';

import '../models/student.dart';

import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final String apiUrl = 'http://10.0.2.2:8000/api';

  StudentBloc() : super(StudentInitial()) {
    on<LoadStudents>((event, emit) async {
      emit(StudentLoading());
      try {
        final response = await http.get(Uri.parse('$apiUrl/students'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final students = data.map((json) => Student.fromJson(json)).toList();
          emit(StudentLoaded(students));
        } else {
          emit(const StudentError('Failed to load students'));
        }
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });

    on<AddStudent>((event, emit) async {
      try {
        final response = await http.post(Uri.parse('$apiUrl/addstudents'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(event.studentData));
        if (response.statusCode == 201) {
          add(LoadStudents());
        } else {
          emit(const StudentError('Failed to add student'));
        }
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });

    on<UpdateStudent>((event, emit) async {
      try {
        final response = await http.put(
            Uri.parse('$apiUrl/updatestudents/${event.id}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(event.studentData));
        if (response.statusCode == 200) {
          add(LoadStudents());
        } else {
          emit(const StudentError('Failed to update student'));
        }
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });

    on<DeleteStudent>((event, emit) async {
      try {
        final response =
            await http.delete(Uri.parse('$apiUrl/deletestudents/${event.id}'));
        if (response.statusCode == 204) {
          add(LoadStudents());
        } else {
          emit(const StudentError('Failed to delete student'));
        }
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });
  }
}
