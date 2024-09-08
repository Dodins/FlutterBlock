import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

@JsonSerializable()
class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final String year;
  final bool enrolled;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    required this.enrolled,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      course: json['course'] as String,
      year: json['year'] as String,
      enrolled: (json['enrolled'] is bool) 
          ? json['enrolled'] as bool
          : (json['enrolled'] == 1), // Convert int 1 to true, 0 to false
    );
  }

  // The method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$StudentToJson(this);
}