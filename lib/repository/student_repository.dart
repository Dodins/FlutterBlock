import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_api_crud_assignment/models/student.dart';

class StudentRepository {
  final String baseUrl = 'http://10.0.2.2:8000/api/allStudents';
  //http://10.0.2.2:8000 - android url
  //http://127.0.0.1:8000 - WEB and IOS url

  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load students");
    }
  }

  Future<void> addStudent(Student student) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add student");
    }
  }

  Future<void> updateStudent(Student student) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${student.id}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update student");
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception("Failed to delete student");
    }
  }
}
