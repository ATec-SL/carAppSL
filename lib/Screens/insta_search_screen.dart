
import 'package:carappsl/Screens/AdCard.dart';
import 'package:carappsl/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carappsl/models/user_model.dart';
import 'package:carappsl/resources/repository.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class InstaSearchScreen extends StatefulWidget {
  @override
  _InstaSearchScreenState createState() => _InstaSearchScreenState();
}

class _InstaSearchScreenState extends State<InstaSearchScreen> {
  var _repository = Repository();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  User _user = User();
  User currentUser;
  List<User> usersList = List<User>();

  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _user.id = user.uid;
      _user.name = user.displayName;
      _user.profileImageUrl = user.photoUrl;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        setState(() {
          currentUser = user;
        });
      });
      print("USER : ${user.displayName}");
      _repository.retrieveSellingVehicles(user).then((updatedList) {
        setState(() {
          list = updatedList;
        });
      });
      _repository.fetchAllUsers(user).then((list) {
        setState(() {
          usersList = list;
        });
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    print("INSIDE BUILD");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Vehicle Selling',
          style: TextStyle(
            color: Colors.black,
          ),
        ),

      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          return  StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return AdCard(list[index].data, context, list[index].documentID);
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );

        }

      ),
    );
  }
}
