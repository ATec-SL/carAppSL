import 'dart:async';

import 'package:carappsl/Screens/create_post_screen.dart';
import 'package:carappsl/Screens/feed_screen.dart';
import 'package:carappsl/Screens/insta_search_screen1.dart';
import 'package:carappsl/Screens/vehicle_selling.dart';
import 'package:carappsl/Screens/profile_screenN.dart';
import 'package:carappsl/Screens/search_screen.dart';
import 'package:carappsl/models/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class HomeScreeen extends StatefulWidget {


  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {

  int currentTab = 0;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<userData>(context).currentUserId;
    return Scaffold(


      body: PageView(
        controller: pageController,
        children: <Widget>[

          FeedScreen(currentUserId: currentUserId,),
          InstaSearchScreen(),
          CreatePostScreen(),
          VehicleSellingScreen(),
          ProfileScreenN(currentUserId: currentUserId, userId: currentUserId ),

        ],
        onPageChanged: (int index){
          setState(() {
            currentTab  = index;
          });

        },
      ),
      bottomNavigationBar: CupertinoTabBar(

        currentIndex: currentTab,
        onTap: (int index){
          setState(() {
            currentTab = index;
          });
          pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn);
        },
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 32.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
                size: 32.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.directions_car,
                size: 32.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: 32.0,
              )
          )
        ],
      ),
    );
  }
}
