import 'package:http/http.dart' as http;
import 'package:bcit_app/courseList/data/course.dart';

class Fetch {
  get(String url) async {
    final http.Response response = await http.get(url);
    Course.parsePhotos(response.body);
    return Course.courseList;
  }
}
