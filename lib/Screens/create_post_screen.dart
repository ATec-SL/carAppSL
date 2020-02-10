import 'dart:io';

import 'package:carappsl/Services/database_service.dart';
import 'package:carappsl/Services/storage_service.dart';
import 'package:carappsl/models/post_model.dart';
import 'package:carappsl/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  File image;

  TextEditingController captionController = TextEditingController();
  String caption = '';
  bool isLoading = false;

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
//      imageFile = await cropImage(imageFile);             New Feature

      setState(() {
        image = imageFile;
      });
    }
  }

  cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
    aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
    );
    return croppedImage;
  }

  submit() async{
    if(!isLoading && image !=null && caption.isNotEmpty){
      setState(() {
        isLoading = true;
      });



      //Create post
      String imageUrl = await StorageService.uploadPost(image);
      Post post = Post(
        imageUrl: imageUrl,
        caption: caption,
        likes: {},
        authorId: Provider.of<userData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );

      DatabaseService.createPost(post);


      //Reset
      captionController.clear();

      setState(() {
        caption = '';
        image = null;
        isLoading =false;
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
            onPressed: () => submit(),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () =>FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: hegiht,
            child: Column(
              children: <Widget>[

                isLoading
                ? Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                )
                : SizedBox.shrink(),
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
                ),

                SizedBox(height: 20.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: captionController,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                        labelText: 'Caption'
                    ),
                    onChanged: (input) => caption = input,
                  ),
                ),
              ],
            ),
          ),
        ),

      )

    );
  }
}