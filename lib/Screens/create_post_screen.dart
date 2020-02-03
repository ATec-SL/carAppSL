import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  File image;

  showSelectImageDialog(){
    return Platform.isIOS ?  iosBottomSheet() : androdidDialog();
  }
  iosBottomSheet(){
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () => handelImage(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Chosse From Gallery'),
                onPressed: () => handelImage(ImageSource.gallery),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  androdidDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
            title: Text('Add Photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () => handelImage(ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text('Chosse From Gallery'),
                onPressed: () => handelImage(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text('Cancel', style: TextStyle(
                  color: Colors.redAccent,
                ),),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
    );

  }

  handelImage(ImageSource source) async{
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if(imageFile != null) {
      setState(() {
        image = imageFile;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hegiht = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showSelectImageDialog(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[

          GestureDetector(
            onTap: showSelectImageDialog,
            child: Container(
                height: width,
                width: width,
              color: Colors.grey[300],
              child:image == null ? Icon(
                Icons.add_a_photo,
                color: Colors.white70,
                size: 150.0,
              )
                  : Image(
                image: FileImage(image),
                fit: BoxFit.cover,
              )
            ),
          )
        ],
      ),

    );
  }
}