import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bcit_app/courseList/util/RESTful/fetch.dart';
import 'package:bcit_app/courseList/util/list/grouper.dart';
import 'package:bcit_app/courseList/data/course.dart';

class CourseList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CourseList();
}

class ExpandableListView extends StatefulWidget {
  final String category;
  final List<Course> courseList;
  final String filter;

  const ExpandableListView(
      {Key key, this.category, this.courseList, this.filter = ""})
      : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;

  ExpandedSection({this.expand = false, this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

///Course list  search bar
///use to search the course
class _CourseList extends State<CourseList> {
  TextEditingController controller = TextEditingController();
  String filter = "";
  Future future = Fetch().get('http://bcitregistration.ddns.net');
  ScrollController scrollController = ScrollController();

  ///init
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    scrollController.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ///search bar
  Widget searchBar() {
    return TextField(
      decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
      controller: controller,
    );
  }

  ///fetch builder + expand list
  Widget listBuilder() {
    return FutureBuilder(
      future: future,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError)
              return new Text('Error');
            else
              return Expanded(child: listView(snapshot.data));
          //_courseList(snapshot.data)
        }
      },
    );
  }

  ///expanded list
  Widget listView(data) {
    Map<String, List<Course>> courseList =
        Grouper<Course, String>().groupMap(data, (Course c) => c.cat);
    return ListView.builder(
      itemBuilder: (context, index) {
        return ExpandableListView(
          category: courseList.keys.elementAt(index),
          courseList: courseList.values.elementAt(index),
          filter: filter,
        );
      },
      itemCount: courseList.length,
      controller: scrollController,
    );
  }

  ///build
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          searchBar(),
          Text('hello'),
          listBuilder()
        ],
      ),
    );
  }
}

/// _ExpandableListViewState
/// expand list view
class _ExpandableListViewState extends State<ExpandableListView>
    with AutomaticKeepAliveClientMixin {
  bool expandFlag = false;
  String category = "";
  String cacheCharacter = "";

  ///init
  @override
  void initState() {
    super.initState();
    if (widget.filter != cacheCharacter) {
      setState(() {
        expandFlag = widget.filter == "" ? false : true;

        cacheCharacter = widget.filter;
      });
    }
  }

  ///onChange
  @override
  void didUpdateWidget(ExpandableListView oldWidget) {
    if (widget.filter != cacheCharacter) {
      setState(() {
        expandFlag = widget.filter == "" ? false : true;
        cacheCharacter = widget.filter;
      });
    }
  }

  ///build
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_listCategory(), _expandedList()],
    );
  }

  ///display icon
  Widget _iconTest() {
    return IconButton(
      icon: new Container(
        child: new Center(
          child: new Icon(
            expandFlag ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.black,
            size: 30.0,
          ),
        ),
      ),
    );
  }

  ///display category
  Widget _listCategory() {
    List<Course> filter = filterList(widget.courseList);
    if (filter.length != 0) {
      return GestureDetector(
        child: Container(
          child: Row(
            children: <Widget>[Text(widget.category), Spacer(), _iconTest()],
          ),
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        ),
        onTap: () {
          setState(() {
            expandFlag = !expandFlag;
          });
        },
      );
    } else {
      return Container();
    }
  }

  ///display list
  Widget _expandedList() {
    return ExpandedSection(
        expand: expandFlag,
        child: Container(
            child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  //List<Course> courseList = widget.courseList;
                  List<Course> filter = filterList(widget.courseList);
                  return ListTile(
                    title: Text(filter.elementAt(index).name),
                  );
                },
                itemCount: filterList(widget.courseList).length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true)));
  }

  List<Course> filterList(List<Course> course) {
    return course
        .where((c) =>
            c.name.toLowerCase().contains(widget.filter.trim().toLowerCase()))
        .toList();
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}

/// _ExpandedSectionState
/// Animate the list expand and collapse
class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  ///init
  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  ///onChange
  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  ///build
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: animation,
        child: widget.expand ? widget.child : null);
  }
}
