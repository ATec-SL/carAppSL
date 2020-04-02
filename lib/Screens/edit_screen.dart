import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carappsl/Services/database_service.dart';
import 'package:carappsl/Services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:carappsl/models/user_model.dart';
import 'package:image_picker/image_picker.dart';


class EditProfileScreen extends StatefulWidget {

  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final formKey = GlobalKey<FormState>();
  File profileImage;
  String name= '';
  String bio = '';
  String brandModel = '';
  String regNo = '';
  String year = '';
  String transmission = '';
  String fuel = '';
  bool sellVehicle;



  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    name = widget.user.name;
    bio = widget.user.bio;
    brandModel = widget.user.brandModel;
    regNo = widget.user.vehiceRegNo;
    year = widget.user.year;
    transmission = widget.user.transmission;
    fuel = widget.user.fuelType;
    sellVehicle = widget.user.sellVehicle;
    if(widget.user.sellVehicle == null){
      sellVehicle = false;
    }

  }

  handleImageFromGallery() async {
    File imageFIle = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFIle != null){
      setState(() {
        profileImage = imageFIle;
      });
    }
  }

  displayProfileImage() {
    // No new profile image
    if (profileImage == null) {
      // No existing profile image
      if (widget.user.profileImageUrl.isEmpty) {
        // Display placeholder
        return AssetImage('assets/images/placeHolder.png');
      } else {
        // User profile image exists
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      // New profile image
      return FileImage(profileImage);
    }
  }

  submit() async {
    if(formKey.currentState.validate() && !isLoading){
      formKey.currentState.save();

      setState(() {
        isLoading = true;
      });
      //Update user in database

      String profileImageUrl = '';

      if(profileImage == null){
        profileImageUrl = widget.user.profileImageUrl;
      }
      else{
        profileImageUrl = await StorageService.uploadUserProfileImage(
          widget.user.profileImageUrl,
          profileImage,
        );
      }

      User user = User(
          id: widget.user.id,
          name: name,
          profileImageUrl: profileImageUrl,
          bio: bio,
        sellVehicle: sellVehicle,
      );

      //Database Update
      DatabaseService.updateUser(user);

      Navigator.pop(context);
    }
  }

  Widget buidCoverImage(Size screenSize){
    return Container(
      height: screenSize.height /5.0,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: displayProfileImage(),
            fit: BoxFit.cover,
          )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),

        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            isLoading ? LinearProgressIndicator(
              backgroundColor: Colors.blue[200],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            )
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(key: formKey,
                child: Column(
                  children: <Widget>[
                    buidCoverImage(screenSize, ),

                    FlatButton(
                      onPressed: handleImageFromGallery,
                      child: Text(
                        'Change Profile Image',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),

                    TextFormField(initialValue: name,

                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            size: 30.0,
                          ),
                          labelText: 'Name'
                      ),
                      validator: (input) => input.trim().length < 1 ? 'Please enter a valid name' : null,
                      onSaved:(input) => name = input ,
                    ),
                    TextFormField(initialValue: bio,

                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.book,
                            size: 30.0,
                          ),
                          labelText: 'Bio'
                      ),
                      validator: (input) => input.trim().length > 150 ? 'Please enter a bio less than 150 characters' : null,
                      onSaved:(input) => bio = input ,
                    ),


                    SizedBox(height: 20.0),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new  Text(
                          'Sell this Car',
                          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        new Switch(

                          value: sellVehicle,
                          onChanged: (value) {
                            setState(() {
                              sellVehicle = value;
                              print(sellVehicle);
                            });
                          },

                          activeTrackColor: Colors.lightBlue,
                          activeColor: Colors.blue,
                        ),
                      ]
                  ),

                    Container(
                      margin: EdgeInsets.all(40.0),
                      height: 40.0, width: 250.0, child: FlatButton(
                      onPressed: submit,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text(
                        'Save Profile',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),)
                  ],
                ),
              ),
            ),
          ],


        ),
      ) ,

    );
  }
}


