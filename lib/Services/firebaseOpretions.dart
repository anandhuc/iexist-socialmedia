import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingUtils.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:provider/provider.dart';

class FirebaseOpretions with ChangeNotifier {
  UploadTask? imageUploadTask;
  String? initUserEmail;
  String? initUserName;
  String? initUserImage;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getuserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getuserAvatar);
    await imageUploadTask!.whenComplete(() => print("Image Uploaded"));

    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          "profile image url======>${Provider.of<LandingUtils>(context, listen: false).userAvatarUrl}");
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print("Fetching user data");
      initUserName = doc.data()?['username'];
      initUserEmail = doc.data()?['useremail'];
      initUserImage = doc.data()?['userimage'];
      print(
        initUserName,
      );
      print(
        initUserEmail,
      );
      print(initUserImage);
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String userUid, dynamic collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete()
        .whenComplete(() {
        //   FirebaseFirestore.instance
        // .collection(collection)
        // .doc(userUid).collection()


      notifyListeners();
    });
  }

  Future updateCaption(String postId, dynamic data) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data)
        .whenComplete(() {
      notifyListeners();
    });
  }

  Future followUser(
      String followingUid,
      String? followingDocId,
      dynamic followingData,
      String? followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followerDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future submitChatroomData(
      String chatRoomNAme, dynamic chatRoomData) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomNAme)
        .set(chatRoomData); 
  }


}
