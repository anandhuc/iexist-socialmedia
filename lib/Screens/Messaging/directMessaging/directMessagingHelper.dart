import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:provider/provider.dart';

class DirectMessagingHelper with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  Widget customAppbar(
      BuildContext context, String reciversname, String reciversimage) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      color: constantColors.darkColor,
      child: Row(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: constantColors.whiteColor,
                  )),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(reciversimage),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(reciversname,
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              )
            ],
          )
        ],
      ),
    );
  }



  sendMessege(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('directchats')
        .doc(documentSnapshot.id)
        .collection('message') 
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserName,
      'userimage':
          Provider.of<FirebaseOpretions>(context, listen: false).initUserImage,
    });
  }
}
