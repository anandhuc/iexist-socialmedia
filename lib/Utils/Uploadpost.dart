import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Home/screenHome.dart';
import 'package:i_exist_1/Screens/Landing_Page/landingServices.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  TextEditingController captionController = TextEditingController();

  late File uploadPostImage;
  File get getUploadPostImage => uploadPostImage;
  late String uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  late UploadTask imagePostUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        ? print("select image")
        : uploadPostImage = File(uploadPostImageVal.path);
    print(uploadPostImageVal?.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print("image upload error");
    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print("Post image uploaded to storage");
    });

    imageReference.getDownloadURL().
    then((imageUrl)
    {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.gallery);
                        // Navigator.pop(context);
                      }),
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.camera);
                        //  Navigator.pop(context);
                      })
                ],
              )
            ],
          ),
        );
      },
    );
  }

  
 
  showPostImage(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.48,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              // CircleAvatar(
              //   backgroundColor: constantColors.transperent,
              //   radius: 60,
              //   backgroundImage: FileImage(uploadPostImage),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Container(
                  height: 300,
                  width: 400,
                  child: Image.file(
                    uploadPostImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text("Reselect"),
                      onPressed: () {
                        selectPostImageType(context);
                      }),
                  MaterialButton(
                      color: constantColors.blueColor,
                      child: Text("Confirm Image"),
                      onPressed: () async {
                        await uploadPostImageToFirebase().whenComplete(() {
                          editPostsheet(context);
                          print("image Uploaded");
                          // Navigator.pop(context);
                        });
                      })
                ],
              )
            ],
          ),
        );
      },
    );
  }

  editPostsheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.image_aspect_ratio,
                                color: constantColors.greenColor,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.fit_screen,
                                color: constantColors.yellowColor,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 300,
                      child: Image.file(
                        uploadPostImage,
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset('lib/Assets/pngs/sunflower.png'),
                    ),
                    Container(
                      height: 110,
                      width: 5,
                      color: constantColors.blueColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: 120,
                        width: 315 , 
                        child: TextField(
                          maxLines: 5,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          maxLength: 100,
                          controller: captionController,
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Add a caption...',
                            hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FloatingActionButton(
                  backgroundColor: constantColors.blueColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () async {
                    Provider.of<FirebaseOpretions>(context, listen: false)
                        .uploadPostData(captionController.text, {
                      'postimage': getUploadPostImageUrl,
                      'caption': captionController.text,
                      'username':
                          Provider.of<FirebaseOpretions>(context, listen: false)
                              .initUserName,
                      'userimage':
                          Provider.of<FirebaseOpretions>(context, listen: false)
                              .initUserImage,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now(),
                      'useremail':
                          Provider.of<FirebaseOpretions>(context, listen: false)
                              .initUserEmail,
                              'reported':false       

                    }).whenComplete(() async { 
                      FirebaseFirestore.instance
                          .collection('users') 
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .collection('posts')
                          .add({
                        'postimage': getUploadPostImageUrl,
                        'caption': captionController.text,
                        'username': Provider.of<FirebaseOpretions>(context,
                                listen: false)
                            .initUserName,
                        'userimage': Provider.of<FirebaseOpretions>(context,
                                listen: false)
                            .initUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now(),
                        'useremail': Provider.of<FirebaseOpretions>(context,
                                listen: false)
                            .initUserEmail,
                      });
                    }).whenComplete(() {
                      int count = 0;
Navigator.of(context).popUntil((_) => count++ >= 3) ;

                    }

               ); })
            ],
          ),
        );
      },
    );
  }
}
