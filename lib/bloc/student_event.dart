import 'package:equatable/equatable.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudents extends StudentEvent {}

class AddStudent extends StudentEvent {
  final Map<String, dynamic> studentData;

  const AddStudent(this.studentData);
}

class UpdateStudent extends StudentEvent {
  final int id;
  final Map<String, dynamic> studentData;

  const UpdateStudent(this.id, this.studentData);
}

class DeleteStudent extends StudentEvent {
  final int id;

  const DeleteStudent(this.id);

  @override
  List<Object> get props => [id];
}
