import 'package:carappsl/models/post_model.dart';
import 'package:carappsl/models/user_model.dart';
import 'package:carappsl/utilties/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static void updateUser(User user){
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
      'sellVehicle': user.sellVehicle

    });
  }
  
  
  static Future<QuerySnapshot> searchUser (String name) {
    Future<QuerySnapshot> users = usersRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  static void createPost(Post post){

    postRef.document(post.authorId).collection('userPosts').add({
      'imageUrl': post.imageUrl,
      'caption': post.caption,
      'likeCount': post.likeCOunt,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    }

    );
  }

  static void followUser ({String currentUserId, String userId}){
    // Add users to current users Following
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});

    //Followers
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  static void unFollowUser ({String currentUserId, String userId}){
    // Remove users to current users Following
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .get().then((doc){
          if(doc.exists){
            doc.reference.delete();
          }
    });

    //Remove Followers
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get().then((doc){
      if(doc.exists){
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser({String currentUserId, String userID}) async{

    DocumentSnapshot followingDoc = await followersRef
        .document(userID)
        .collection('userFollowers')
        .document(currentUserId)
        .get();

    return followingDoc.exists;
  }

  static Future<int> numFollowing(String userId) async{

    QuerySnapshot followingSnapshot = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();

    return followingSnapshot.documents.length;
  }

  static Future<int> numFollowers(String userId) async{

    QuerySnapshot followersSnapshot = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();

    return followersSnapshot.documents.length;
  }

  static Future<List<Post>> getFeedPosts(String userId) async{
    QuerySnapshot feedSnapshot = await feedRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<Post> posts = feedSnapshot.documents.map((doc) => Post.fromDoc((doc))).toList();

    return posts;
  }

  static Future<List<Post>>  getUserPosts(String userId) async{
    QuerySnapshot userPostsSnapshot = await postRef
        .document(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<Post> posts = userPostsSnapshot.documents.map((doc) => Post.fromDoc((doc))).toList();

    return posts;
  }

  static Future<User> getUserWithId(String userId) async{
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if(userDocSnapshot.exists){
      return User.fromDoc(userDocSnapshot);
    }

    return User();
  }

  static void likePost({String currentUserId, Post post}){

    DocumentReference postsRef = postRef.document(post.authorId).collection('userPosts').document(post.id);

    postsRef.get().then((doc) {

      int likeCount = doc.data['likeCount'];
      postsRef.updateData(({'likeCount': likeCount + 1}));
      likesRef
      .document(post.id)
      .collection('postLikes')
      .document(currentUserId)
      .setData({});
    });
  }

  static void unLikePost({String currentUserId, Post post}){
    DocumentReference postsRef = postRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);

        postsRef.get().then((doc) {
          int likeCOunt = doc.data['likeCount'];
          postsRef.updateData({'likeCount' : likeCOunt - 1});

          likesRef
              .document(post.id)
              .collection('postLikes')
              .document(currentUserId)
              .get()
          .then((doc) {if(doc.exists) {
            doc.reference.delete();
          }});
        });


  }

  static Future<bool> didLikePost({String currentUserId, Post post}) async {
    DocumentSnapshot userDoc = await likesRef
    .document(post.id)
        .collection('postLikes')
        .document(currentUserId)
        .get();
    return userDoc.exists;

  }

  static void commentOnPost({String currentUserId, String postId, String comment}){
    commentRef.document(postId).collection('postComments').add({
      'content': comment,
      'authorId': currentUserId,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }



  }