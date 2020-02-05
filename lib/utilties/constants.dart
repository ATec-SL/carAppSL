

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = firestore.collection('users');
final postRef = firestore.collection('posts');
final followingRef = firestore.collection('following');
final followersRef = firestore.collection('followers');

