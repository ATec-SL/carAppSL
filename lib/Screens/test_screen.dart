import 'package:carappsl/models/user_model.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  final String userId;

  TestScreen({this.userId});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String name = 'Akash Jayaweera';

  Widget buidCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 4.5,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/cover.jpg'),
        fit: BoxFit.cover,
      )),
    );
  }

  Widget buildFullName() {
    TextStyle naeTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );
    return Text(
      name,
      style: naeTextStyle,
    );
  }

  Widget buildStatContainer() {
    TextStyle ststLabeltextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Roboto',
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle statCounttextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFeFF4F),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildStatItem("Posts", "220"),
          buildStatItem("Followers", "220"),
          buildStatItem("Following", "220")
        ],
      ),
    );
  }

  Widget buildStatItem(String label, String count) {
    TextStyle ststLabeltextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Roboto',
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle statCounttextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      children: <Widget>[
        Text(
          count,
          style: statCounttextStyle,
        ),
        Text(
          label,
          style: ststLabeltextStyle,
        )
      ],
    );
  }

  Widget buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/u1.jpg'), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(80.0),
            border: Border.all(
              color: Colors.white,
              width: 10.0,
            )),
      ),
    );
  }

  Widget vehicleDetails(BuildContext context) {
    TextStyle modelBrand = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Vehicle Model/Brand: Toyota Wigo',
        textAlign: TextAlign.center,
        style: modelBrand,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          buidCoverImage(
            screenSize,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: screenSize.height / 7.4,
                  ),
                  buildProfileImage(),
                  buildFullName(),
                  buildStatContainer(),
                  vehicleDetails(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
