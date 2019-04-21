import 'package:flutter/material.dart';
import 'package:bcit_app/courseList//widget/courseListPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter App',
      home: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              title: Text('BCIT Courses'),
              centerTitle: true,
            ),
          ),
          body: CourseList(),
      ),
    );
  }
}
