import 'dart:convert';

class Course {
  final String name;
  final String link;
  final String cat;
  static List<Course> courseList = List();

  Course({this.name, this.link, this.cat});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
      link: json['link'],
      cat: json['cat'],
    );
  }

  static parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    courseList = parsed.map<Course>((json) => Course.fromJson(json)).toList();
  }
}
