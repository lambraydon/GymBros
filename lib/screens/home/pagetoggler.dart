import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:gymbros/screens/home/home.dart';
import 'package:gymbros/services/authservice.dart';

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
    // TODO: implement initState
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Text("home"),
          Text("post"),
          Home()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
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