// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:i_exist_1/Screens/Stories/stories_widget.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoriesHelper with ChangeNotifier {
  late UploadTask imageUploadTask;
  final picker = ImagePicker();
  late File storyImage;
  File? get getStoryImage => storyImage;
  final StoryWidgets storyWidgets = StoryWidgets();
  late String storyImageUrl;
  String get getStoryImageUrl => storyImageUrl;
  late String storyHighlightIcon;
  String get getstoryHighlightIcon => storyHighlightIcon;
  late String storyTime;
  String get getstoryTime => storyTime;

  Future selectStoryImage(BuildContext context, ImageSource source) async {
    final pickedStoryImage = await picker.pickImage(source: source);
    pickedStoryImage == null
        ? print('error')
        : storyImage = File(pickedStoryImage.path);
    storyImage != null
        ? storyWidgets.previewStoryImage(context, storyImage)
        : print('error');
    notifyListeners();
  }

  Future uploadStoryImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('stories/${getStoryImage!.path}/${Timestamp.now()}');

    imageUploadTask = imageReference.putFile(getStoryImage!);
    await imageUploadTask.whenComplete(() {
      print('Story image uploaded');
    });

    imageReference.getDownloadURL().then((url) {
      storyImageUrl = url;
      print(storyImageUrl);
      notifyListeners();
    });
  }

  // Future convertHighlightedIcon(String firestoreImageUrl) async {
  //   storyHighlightIcon = firestoreImageUrl;
  //   print(storyHighlightIcon);
  //   notifyListeners();
  // }



  Future addStoryToExistingAlbum(BuildContext context, String? userUID,
      String highlightcollId, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('highlights')
        .doc(highlightcollId).collection('Stories').add({
          'image':storyImage,
          'username':Provider.of<FirebaseOpretions>(context,listen: false).initUserName,
          'userimage':Provider.of<FirebaseOpretions>(context,listen: false).initUserImage
        });
        
  }








  // Future addStoryToNewAlbum(BuildContext context, String? userUID,
  //     String highlightName, String storyImage) async {
  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userUID)
  //       .collection('highlights')
  //       .doc(highlightName)
  //       .set({
  //     'title': highlightName,
  //     'cover': storyHighlightIcon
  //   }).whenComplete(() {
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userUID)
  //         .collection('highlights')
  //         .doc(highlightName)
  //         .collection('stories')
  //         .add({
  //       'image': getStoryImageUrl,
  //       'username':
  //           Provider.of<FirebaseOpretions>(context, listen: false).initUserName,
  //       'userimage': Provider.of<FirebaseOpretions>(context, listen: false)
  //           .initUserImage,
  //     });
  //   });
  // }

  storyTimePosted(dynamic timedata) {
    Timestamp timestamp = timedata;
    DateTime dateTime = timestamp.toDate();
    storyTime = timeago.format(dateTime);
    notifyListeners();
  }

  Future addSeenStamp(BuildContext context, String storyId, String? personId,
      DocumentSnapshot documentSnapshot)async{ 
        print('seen');
    if (documentSnapshot['useruid'] !=
        Provider.of<Authentication>(context, listen: false).getUserUid) {
      return FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .collection('seen')
          .doc(personId)
          .set({
        'time': TimeOfDay.now(),
        'username':
            Provider.of<FirebaseOpretions>(context, listen: false).initUserName,
        'userimage': Provider.of<FirebaseOpretions>(context, listen: false)
            .initUserImage,
        'useruid':
            Provider.of<Authentication>(context, listen: false).getUserUid
      });
    }
  }
}
