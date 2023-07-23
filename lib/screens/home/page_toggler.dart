import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:gymbros/screens/home/my_profile.dart';
import 'package:gymbros/screens/socialmedia/feed.dart';
import 'package:gymbros/screens/workoutTracker/workout_history.dart';

class PageToggler extends StatefulWidget {
  const PageToggler({super.key});

  @override
  State<PageToggler> createState() => _PageTogglerState();
}

class _PageTogglerState extends State<PageToggler> {

  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }
  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        //nest other screen widgets in the children input
        children: const [
          Feed(),
          WorkoutHistory(),
          MyProfile()
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
              icon:Icon(Icons.home, color: _page == 0 ? Colors.black45:Colors.grey[400]),
              label: "",
              backgroundColor: Colors.grey[400]
          ),
          BottomNavigationBarItem(
              icon:Icon(Icons.add_circle_outlined, color: _page == 1 ? Colors.black45:Colors.grey[400]),
              label: "",
              backgroundColor: Colors.grey[400]
          ),
          BottomNavigationBarItem(
              icon:Icon(Icons.person, color: _page == 2 ? Colors.black45:Colors.grey[400]),
              label: "",
              backgroundColor: Colors.grey[400]
          ),
        ],
        onTap: navigationTapped,
      ) ,
    );
  }
}