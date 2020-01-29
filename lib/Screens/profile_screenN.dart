import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:carappsl/models/user_model.dart';
import 'package:carappsl/Screens/edit_screen.dart';
import 'package:carappsl/utilties/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProfileScreenN extends StatefulWidget {

  final String userId;

  ProfileScreenN({this.userId});
  @override
  _ProfileScreenNState createState() => _ProfileScreenNState();
}

class _ProfileScreenNState extends State<ProfileScreenN> {

  Widget buidCoverImage(Size screenSize, User user){
    return Container(
      height: screenSize.height /3.5,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: user.profileImageUrl.isEmpty
                ? AssetImage('assets/images/placeHolder.png')
                : CachedNetworkImageProvider(user.profileImageUrl),
            fit: BoxFit.cover,
          )
      ),
    );
  }

  Widget buildFullName(User user){
    TextStyle naeTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );
    return Text(
      user.name,
      style: naeTextStyle,
    );
  }

  Widget buildStatContainer(){
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
//        color: Color(0xFFeFF4F),

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

  Widget buildStatItem( String label, String count){

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

  Widget buildProfileImage(User user){
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: user.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/placeHolder.png')
                    : CachedNetworkImageProvider(user.profileImageUrl),
                fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(80.0),
            border: Border.all(
              color:Colors.white,
              width: 10.0,
            )
        ),

      ),
    );
  }

  Widget vehicleDetails(BuildContext context, String label, String value){
    TextStyle modelBrand = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: RichText(
        text: new TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            new TextSpan(text: label),
            new TextSpan(text: value , style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18.0)),

          ],

        ),
      ),
    );
  }

  Widget editButton(User user){
    return  Container(
      width: 200.0,
      child: FlatButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => EditProfileScreen(user: user,)
            )),
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18.0),

        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Zonegram',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Pacifico',
              fontSize: 35.0,
            ),
          ),
        ),
        backgroundColor: Colors.white,

        body: FutureBuilder(

          future: usersRef.document(widget.userId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            User user = User.fromDoc(snapshot.data);
            return Scaffold(

              body: Stack(
                children: <Widget>[
              SafeArea(

                child: SingleChildScrollView(

                  child: Column(
                    children: <Widget>[
                      buidCoverImage(screenSize, user),
                      SizedBox(height: screenSize.height / 58.4,),

//                      buildProfileImage(user),
                      buildFullName(user),
                      buildStatContainer(),
                      vehicleDetails(context, "Mobel / Brand : ", user.brandModel),
                      vehicleDetails(context, "Registration No : ", user.vehiceRegNo),
                      vehicleDetails(context, "Model Year : ", user.year),
                      vehicleDetails(context, "Transmission : ", user.transmission),
                      vehicleDetails(context, "Fuel Type : ", user.fuelType),
                      vehicleDetails(context, "", user.bio),
                      editButton(user)

                    ],
                  ),
                ),
              ),


                ],

              ),
            );
          },
        )

    );
  }
}
