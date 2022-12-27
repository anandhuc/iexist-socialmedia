import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/AltProfile/alt_Profile.dart';
import 'package:i_exist_1/Screens/Home/screenHome.dart';
import 'package:i_exist_1/Screens/Messaging/groupMessaging/groupMessaging.dart';
import 'package:i_exist_1/Services/Authentication.dart';
import 'package:i_exist_1/Services/firebaseOpretions.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomHelper with ChangeNotifier {
  late String lastestMesssageTime;
  String get getLatestMessageTime => lastestMesssageTime;
  String? chatRoomAvatarUrl, chatroomID;
  String? get getChatRoomAvatarUrl => chatRoomAvatarUrl;
  String? get getChatroomID => chatroomID;
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController chatRoomNameController = TextEditingController();

  showCreateChatroomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Text(
                  'Select Chatroom Avatar',
                  style: TextStyle(
                      color: constantColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatroomIcons')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color:
                                    constantColors.greyColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      chatRoomAvatarUrl =
                                          documentSnapshot['image'];
                                      print(chatRoomAvatarUrl);
                                      notifyListeners();
                                    },
                                    child: Container(
                                      height: 10,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: chatRoomAvatarUrl ==
                                                      documentSnapshot['image']
                                                  ? constantColors.whiteColor
                                                  : constantColors
                                                      .transperent)),
                                      child: Image.network(
                                        documentSnapshot['image'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: chatRoomNameController,
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        decoration: InputDecoration(
                            hintText: 'Enter Chatroom ID',
                            hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        Provider.of<FirebaseOpretions>(context, listen: false)
                            .submitChatroomData(chatRoomNameController.text, {
                          'roomavatar': getChatRoomAvatarUrl,
                          'time': Timestamp.now(),
                          'roomname': chatRoomNameController.text,
                          'username': Provider.of<FirebaseOpretions>(context,
                                  listen: false)
                              .initUserName,
                          'userimage': Provider.of<FirebaseOpretions>(context,
                                  listen: false)
                              .initUserImage,
                          'useremail': Provider.of<FirebaseOpretions>(context,
                                  listen: false)
                              .initUserEmail,
                          'useruid': Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid,
                        }).whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      backgroundColor: constantColors.blueGreyColor,
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: constantColors.whiteColor,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showChatRoomDetials(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.27,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
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
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: constantColors.yellowColor),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        ' Admin ',
                        style: TextStyle(
                            color: constantColors.yellowColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .068,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: constantColors.transperent,
                            backgroundImage:
                                NetworkImage(documentSnapshot['userimage']),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  documentSnapshot['username'],
                                  style: TextStyle(
                                      color: constantColors.yellowColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                             Provider.of<Authentication>(context,listen: false).getUserUid == documentSnapshot['useruid']?
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  height: 25,
                                  width: 120,
                                  child: MaterialButton(
                                      color: constantColors.redColor,
                                      child: Text(
                                        'Delete Room',
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              title: Text(
                                                'Delete ?',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color:
                                                                  constantColors
                                                                      .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        )),
                                                    MaterialButton(
                                                        color: constantColors
                                                            .redColor,
                                                        child: Text(
                                                          'Delete Room',
                                                          style: TextStyle(
                                                              color:
                                                                  constantColors
                                                                      .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'chatrooms')
                                                              .doc(
                                                                  documentSnapshot
                                                                      .id)
                                                              .collection(
                                                                  'members')
                                                              .doc(Provider.of<
                                                                          Authentication>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getUserUid)
                                                              .delete()
                                                              .whenComplete(() {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        })
                                                  ],
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }),
                                ),
                              ):SizedBox() 
                            ]
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.blueColor),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  ' members ',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.128,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(documentSnapshot.id)
                      .collection('members')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot documentSnapshot) {
                          return GestureDetector(
                            onTap: () {
                              if (Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid !=
                                  documentSnapshot['useruid']) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: AltProfile(
                                            useruid:
                                                documentSnapshot['useruid']),
                                        type: PageTransitionType.bottomToTop));
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: constantColors.greyColor,
                                backgroundImage:
                                    NetworkImage(documentSnapshot['userimage']),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showChatrooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset('lib/Assets/animations/blueball.json'),
          ));
        } else {
          return ListView(
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
            return ListTile(
              onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: GroupMesseging(documentSnapshot: documentSnapshot),
                      type: PageTransitionType.rightToLeft)),
              onLongPress: () => showChatRoomDetials(context, documentSnapshot),
              leading: CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage: NetworkImage(documentSnapshot['roomavatar']),
              ),
              title: Text(
                documentSnapshot['roomname'],
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              // subtitle: StreamBuilder(
              //   stream: FirebaseFirestore.instance
              //       .collection('chatrooms')
              //       .doc(documentSnapshot.id)
              //       .collection('message')
              //       .orderBy('time', descending: true)
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     } else if (snapshot.data!.docs.first['username'] != null &&
              //         snapshot.data!.docs.first['message'] != null) {
              //       return Text(
              //         '${snapshot.data!.docs.first['username']}: ${snapshot.data!.docs.first['message']}',
              //         style: TextStyle(
              //             color: constantColors.greenColor,
              //             fontSize: 14,
              //             fontWeight: FontWeight.w100),
              //       );
              //     } else {
              //       return SizedBox();
              //     }
              //   },
              // ),
              // trailing:

              //  StreamBuilder<QuerySnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection('chatrooms')
              //       .doc(documentSnapshot.id)
              //       .collection('message')
              //       .orderBy('time', descending: true)
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     showLastMessageTime(snapshot.data!.docs.first['time']);
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     } else {
              //       return Text(
              //        getLatestMessageTime,
              //         style: TextStyle(
              //             color: constantColors.greenColor,
              //             fontSize: 8,
              //             fontWeight: FontWeight.w100),
              //       );
              //     }
              //   },
              // )
            );
          }).toList());
        }
      },
    );
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    lastestMesssageTime = timeago.format(dateTime);
    notifyListeners();
  }
}
